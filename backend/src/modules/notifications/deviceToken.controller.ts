import { Request, Response } from 'express';
import { z } from 'zod';
import { db } from '../../config/database';
import { ValidationError } from '../../errors/AppError';

// Scaffolding only: stores the token so a future push-notification
// integration (FCM/APNs) can send to it. No push sending is implemented yet.
const deviceTokenSchema = z.object({
  token: z.string().min(1),
  platform: z.enum(['android', 'ios']),
});

export async function registerDeviceToken(req: Request, res: Response): Promise<void> {
  const parsed = deviceTokenSchema.safeParse(req.body);
  if (!parsed.success) {
    throw new ValidationError('token and platform are required.', parsed.error.issues);
  }

  await db('device_tokens')
    .insert({ user_id: req.user!.id, token: parsed.data.token, platform: parsed.data.platform })
    .onConflict('token')
    .merge({ user_id: req.user!.id, platform: parsed.data.platform });

  res.status(201).json({ success: true, data: null, message: 'Device token registered' });
}
