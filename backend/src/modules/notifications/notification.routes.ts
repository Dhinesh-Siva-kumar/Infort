import { Router } from 'express';
import { asyncHandler } from '../../utils/asyncHandler';
import { authenticate, requireRole } from '../../middleware/authenticate';
import { listNotifications, markRead, markAllRead } from './notification.controller';
import { registerDeviceToken } from './deviceToken.controller';

export const notificationRouter = Router();

notificationRouter.use(authenticate, requireRole('FOUNDER'));
notificationRouter.get('/', asyncHandler(listNotifications));
notificationRouter.patch('/read-all', asyncHandler(markAllRead));
notificationRouter.patch('/:id/read', asyncHandler(markRead));
notificationRouter.post('/device-token', asyncHandler(registerDeviceToken));
