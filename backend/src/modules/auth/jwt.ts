import jwt from 'jsonwebtoken';
import { env } from '../../config/env';
import { UserRole } from '../users/user.types';

export interface AccessTokenPayload {
  sub: number;
  role: UserRole;
}

export function signAccessToken(payload: AccessTokenPayload): string {
  return jwt.sign(payload, env.jwt.accessSecret, { expiresIn: env.jwt.accessExpiresIn as jwt.SignOptions['expiresIn'] });
}

export function verifyAccessToken(token: string): AccessTokenPayload {
  return jwt.verify(token, env.jwt.accessSecret) as unknown as AccessTokenPayload;
}

export function signRefreshToken(payload: AccessTokenPayload): string {
  return jwt.sign(payload, env.jwt.refreshSecret, { expiresIn: env.jwt.refreshExpiresIn as jwt.SignOptions['expiresIn'] });
}

export function verifyRefreshToken(token: string): AccessTokenPayload {
  return jwt.verify(token, env.jwt.refreshSecret) as unknown as AccessTokenPayload;
}

export function refreshTokenExpiryDate(): Date {
  const match = /^(\d+)([smhd])$/.exec(env.jwt.refreshExpiresIn);
  const amount = match ? Number(match[1]) : 30;
  const unit = match ? match[2] : 'd';
  const unitMs: Record<string, number> = { s: 1000, m: 60_000, h: 3_600_000, d: 86_400_000 };
  return new Date(Date.now() + amount * (unitMs[unit] ?? unitMs['d']));
}
