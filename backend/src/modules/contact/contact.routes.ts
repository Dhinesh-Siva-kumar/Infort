import { Router } from 'express';
import rateLimit from 'express-rate-limit';
import { asyncHandler } from '../../utils/asyncHandler';
import { submitContact } from './contact.controller';

const contactRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many submissions from this device. Please try again later.',
    code: 'RATE_LIMITED',
    errors: [],
  },
});

export const contactRouter = Router();

contactRouter.post('/', contactRateLimit, asyncHandler(submitContact));
