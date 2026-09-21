import { Request, Response } from 'express';
import { UserRepository } from './user.repository';
import { toPublicUser } from './user.types';
import { updateProfileSchema } from './user.validator';
import { NotFoundError, ValidationError } from '../../errors/AppError';

const users = new UserRepository();

export async function getProfile(req: Request, res: Response): Promise<void> {
  const user = await users.findById(req.user!.id);
  if (!user) {
    throw new NotFoundError('User not found');
  }

  res.json({ success: true, data: toPublicUser(user), message: 'OK' });
}

export async function updateProfile(req: Request, res: Response): Promise<void> {
  const parsed = updateProfileSchema.safeParse(req.body);
  if (!parsed.success) {
    throw new ValidationError('Please check the submitted fields.', parsed.error.issues);
  }

  const updated = await users.updateProfile(req.user!.id, parsed.data);
  res.json({ success: true, data: toPublicUser(updated), message: 'Profile updated' });
}
