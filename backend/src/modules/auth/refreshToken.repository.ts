import crypto from 'crypto';
import { db } from '../../config/database';

export interface RefreshTokenRow {
  id: number;
  user_id: number;
  token_hash: string;
  expires_at: Date;
  revoked_at: Date | null;
  created_at: Date;
}

function hashToken(token: string): string {
  return crypto.createHash('sha256').update(token).digest('hex');
}

export class RefreshTokenRepository {
  async create(userId: number, token: string, expiresAt: Date): Promise<void> {
    await db<RefreshTokenRow>('refresh_tokens').insert({
      user_id: userId,
      token_hash: hashToken(token),
      expires_at: expiresAt,
    });
  }

  async findValidByToken(token: string): Promise<RefreshTokenRow | undefined> {
    return db<RefreshTokenRow>('refresh_tokens')
      .where({ token_hash: hashToken(token) })
      .whereNull('revoked_at')
      .andWhere('expires_at', '>', new Date())
      .first();
  }

  async revoke(token: string): Promise<void> {
    await db<RefreshTokenRow>('refresh_tokens')
      .where({ token_hash: hashToken(token) })
      .update({ revoked_at: new Date() });
  }

  async revokeAllForUser(userId: number): Promise<void> {
    await db<RefreshTokenRow>('refresh_tokens').where({ user_id: userId }).whereNull('revoked_at').update({
      revoked_at: new Date(),
    });
  }
}
