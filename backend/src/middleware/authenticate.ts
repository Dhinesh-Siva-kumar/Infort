import { NextFunction, Request, Response } from 'express';
import { AuthenticationError, AuthorizationError } from '../errors/AppError';
import { verifyAccessToken } from '../modules/auth/jwt';
import { UserRole } from '../modules/users/user.types';

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      user?: { id: number; role: UserRole };
    }
  }
}

export function authenticate(req: Request, _res: Response, next: NextFunction): void {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    throw new AuthenticationError('Missing or invalid Authorization header');
  }

  try {
    const payload = verifyAccessToken(header.slice('Bearer '.length));
    req.user = { id: payload.sub, role: payload.role };
    next();
  } catch {
    throw new AuthenticationError('Invalid or expired access token');
  }
}

export function requireRole(...roles: UserRole[]) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    if (!req.user || !roles.includes(req.user.role)) {
      throw new AuthorizationError();
    }
    next();
  };
}
