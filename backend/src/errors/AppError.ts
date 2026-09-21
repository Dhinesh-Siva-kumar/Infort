export class AppError extends Error {
  constructor(
    message: string,
    public readonly statusCode: number,
    public readonly code: string,
    public readonly details: unknown[] = []
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

export class ValidationError extends AppError {
  constructor(message: string, details: unknown[] = []) {
    super(message, 400, 'VALIDATION_ERROR', details);
  }
}

export class NotFoundError extends AppError {
  constructor(message = 'Resource not found') {
    super(message, 404, 'NOT_FOUND');
  }
}

export class DatabaseError extends AppError {
  constructor(message = 'A database error occurred') {
    super(message, 500, 'DATABASE_ERROR');
  }
}

export class AuthenticationError extends AppError {
  constructor(message = 'Invalid credentials') {
    super(message, 401, 'AUTHENTICATION_ERROR');
  }
}

export class AuthorizationError extends AppError {
  constructor(message = 'You are not allowed to perform this action') {
    super(message, 403, 'AUTHORIZATION_ERROR');
  }
}
