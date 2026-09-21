import { NextFunction, Request, Response } from 'express';
import { AppError } from '../errors/AppError';
import { env } from '../config/env';

export function notFoundHandler(req: Request, res: Response): void {
  res.status(404).json({
    success: false,
    message: `Route not found: ${req.method} ${req.originalUrl}`,
    code: 'ROUTE_NOT_FOUND',
    errors: [],
  });
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export function errorHandler(err: unknown, req: Request, res: Response, next: NextFunction): void {
  if (err instanceof AppError) {
    res.status(err.statusCode).json({
      success: false,
      message: err.message,
      code: err.code,
      errors: err.details,
    });
    return;
  }

  console.error('[unhandled error]', err);

  res.status(500).json({
    success: false,
    message: env.isProduction ? 'Something went wrong. Please try again later.' : String(err),
    code: 'INTERNAL_SERVER_ERROR',
    errors: [],
  });
}
