import { Request, Response } from 'express';
import { NotificationRepository } from './notification.repository';
import { paginationSchema } from '../../shared/pagination';
import { ValidationError } from '../../errors/AppError';

const notifications = new NotificationRepository();

export async function listNotifications(req: Request, res: Response): Promise<void> {
  const parsed = paginationSchema.safeParse(req.query);
  if (!parsed.success) {
    throw new ValidationError('Invalid pagination parameters.', parsed.error.issues);
  }

  const result = await notifications.findForUser(req.user!.id, parsed.data.page, parsed.data.limit);

  res.json({
    success: true,
    data: result.items,
    message: 'OK',
    meta: { page: result.page, limit: result.limit, total: result.total },
  });
}

export async function markRead(req: Request, res: Response): Promise<void> {
  await notifications.markRead(Number(req.params['id']), req.user!.id);
  res.json({ success: true, data: null, message: 'Notification marked as read' });
}

export async function markAllRead(req: Request, res: Response): Promise<void> {
  await notifications.markAllRead(req.user!.id);
  res.json({ success: true, data: null, message: 'All notifications marked as read' });
}
