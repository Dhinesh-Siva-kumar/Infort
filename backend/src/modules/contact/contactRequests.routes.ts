import { Router } from 'express';
import { asyncHandler } from '../../utils/asyncHandler';
import { authenticate, requireRole } from '../../middleware/authenticate';
import {
  listContactRequests,
  getContactRequest,
  getContactRequestsSummary,
  updateContactRequestStatus,
} from './contact.controller';

// Founder-only read/manage endpoints for contact submissions.
// The public write endpoint (POST /api/contact) lives in contact.routes.ts.
export const contactRequestsRouter = Router();

contactRequestsRouter.use(authenticate, requireRole('FOUNDER'));
contactRequestsRouter.get('/', asyncHandler(listContactRequests));
contactRequestsRouter.get('/summary', asyncHandler(getContactRequestsSummary));
contactRequestsRouter.get('/:id', asyncHandler(getContactRequest));
contactRequestsRouter.patch('/:id/status', asyncHandler(updateContactRequestStatus));
