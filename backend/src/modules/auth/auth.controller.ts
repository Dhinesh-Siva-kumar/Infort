import { Request, Response } from 'express';
import { loginSchema, refreshSchema, changePasswordSchema } from './auth.validator';
import { AuthService } from './auth.service';
import { ValidationError } from '../../errors/AppError';

const authService = new AuthService();

export async function login(req: Request, res: Response): Promise<void> {
  const parsed = loginSchema.safeParse(req.body);
  if (!parsed.success) {
    throw new ValidationError('Please check your email and password.', parsed.error.issues);
  }

  const { user, tokens } = await authService.login(parsed.data.email, parsed.data.password);

  res.json({
    success: true,
    data: { user, ...tokens },
    message: 'Logged in successfully',
  });
}

export async function refresh(req: Request, res: Response): Promise<void> {
  const parsed = refreshSchema.safeParse(req.body);
  if (!parsed.success) {
    throw new ValidationError('refreshToken is required.', parsed.error.issues);
  }

  const tokens = await authService.refresh(parsed.data.refreshToken);

  res.json({ success: true, data: tokens, message: 'Token refreshed' });
}

export async function logout(req: Request, res: Response): Promise<void> {
  const parsed = refreshSchema.safeParse(req.body);
  if (!parsed.success) {
    throw new ValidationError('refreshToken is required.', parsed.error.issues);
  }

  await authService.logout(parsed.data.refreshToken);

  res.json({ success: true, data: null, message: 'Logged out successfully' });
}

export async function changePassword(req: Request, res: Response): Promise<void> {
  const parsed = changePasswordSchema.safeParse(req.body);
  if (!parsed.success) {
    throw new ValidationError('Please check the password fields.', parsed.error.issues);
  }

  await authService.changePassword(req.user!.id, parsed.data.currentPassword, parsed.data.newPassword);

  res.json({ success: true, data: null, message: 'Password changed successfully' });
}
