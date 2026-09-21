import bcrypt from 'bcryptjs';
import { UserRepository } from '../users/user.repository';
import { RefreshTokenRepository } from './refreshToken.repository';
import { AuthenticationError } from '../../errors/AppError';
import { PublicUser, toPublicUser } from '../users/user.types';
import {
  refreshTokenExpiryDate,
  signAccessToken,
  signRefreshToken,
  verifyRefreshToken,
} from './jwt';

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
}

export class AuthService {
  constructor(
    private readonly users: UserRepository = new UserRepository(),
    private readonly refreshTokens: RefreshTokenRepository = new RefreshTokenRepository()
  ) {}

  async login(email: string, password: string): Promise<{ user: PublicUser; tokens: AuthTokens }> {
    const user = await this.users.findByEmail(email);
    if (!user || !user.is_active) {
      throw new AuthenticationError('Invalid email or password');
    }

    const passwordMatches = await bcrypt.compare(password, user.password_hash);
    if (!passwordMatches) {
      throw new AuthenticationError('Invalid email or password');
    }

    const tokens = await this.issueTokens(user.id, user.role);
    return { user: toPublicUser(user), tokens };
  }

  async refresh(token: string): Promise<AuthTokens> {
    let payload;
    try {
      payload = verifyRefreshToken(token);
    } catch {
      throw new AuthenticationError('Invalid or expired refresh token');
    }

    const stored = await this.refreshTokens.findValidByToken(token);
    if (!stored) {
      throw new AuthenticationError('Invalid or expired refresh token');
    }

    // Rotate: revoke the used refresh token and issue a new pair.
    await this.refreshTokens.revoke(token);
    return this.issueTokens(payload.sub, payload.role);
  }

  async logout(token: string): Promise<void> {
    await this.refreshTokens.revoke(token);
  }

  async changePassword(userId: number, currentPassword: string, newPassword: string): Promise<void> {
    const user = await this.users.findById(userId);
    if (!user) {
      throw new AuthenticationError('User not found');
    }

    const passwordMatches = await bcrypt.compare(currentPassword, user.password_hash);
    if (!passwordMatches) {
      throw new AuthenticationError('Current password is incorrect');
    }

    const newHash = await bcrypt.hash(newPassword, 12);
    await this.users.updatePasswordHash(userId, newHash);
    await this.refreshTokens.revokeAllForUser(userId);
  }

  private async issueTokens(userId: number, role: 'FOUNDER'): Promise<AuthTokens> {
    const accessToken = signAccessToken({ sub: userId, role });
    const refreshToken = signRefreshToken({ sub: userId, role });
    await this.refreshTokens.create(userId, refreshToken, refreshTokenExpiryDate());
    return { accessToken, refreshToken };
  }
}
