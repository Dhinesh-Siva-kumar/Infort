import { Router } from 'express';
import { asyncHandler } from '../../utils/asyncHandler';
import { authenticate, requireRole } from '../../middleware/authenticate';
import { getProfile, updateProfile } from './user.controller';

export const profileRouter = Router();

profileRouter.use(authenticate, requireRole('FOUNDER'));
profileRouter.get('/', asyncHandler(getProfile));
profileRouter.patch('/', asyncHandler(updateProfile));
