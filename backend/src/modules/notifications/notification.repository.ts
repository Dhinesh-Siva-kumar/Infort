import { db } from '../../config/database';
import { Notification } from './notification.types';

export interface PaginatedNotifications {
  items: Notification[];
  page: number;
  limit: number;
  total: number;
}

export class NotificationRepository {
  async create(input: {
    userId: number;
    type: string;
    title: string;
    body: string;
    contactSubmissionId?: number;
  }): Promise<Notification> {
    const [row] = await db<Notification>('notifications')
      .insert({
        user_id: input.userId,
        type: input.type,
        title: input.title,
        body: input.body,
        contact_submission_id: input.contactSubmissionId ?? null,
      })
      .returning('*');
    return row;
  }

  async findForUser(userId: number, page: number, limit: number): Promise<PaginatedNotifications> {
    const query = db<Notification>('notifications').where({ user_id: userId });

    const [items, [{ count }]] = await Promise.all([
      query
        .clone()
        .orderBy('created_at', 'desc')
        .limit(limit)
        .offset((page - 1) * limit),
      db<Notification>('notifications').where({ user_id: userId }).count<{ count: string }[]>('id as count'),
    ]);

    return { items, page, limit, total: Number(count) };
  }

  async markRead(id: number, userId: number): Promise<void> {
    await db<Notification>('notifications').where({ id, user_id: userId }).update({ read_at: new Date() });
  }

  async markAllRead(userId: number): Promise<void> {
    await db<Notification>('notifications').where({ user_id: userId }).whereNull('read_at').update({ read_at: new Date() });
  }
}
