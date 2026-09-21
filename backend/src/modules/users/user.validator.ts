import { z } from 'zod';

export const updateProfileSchema = z.object({
  name: z.string().trim().min(2).optional(),
  phone: z.string().trim().min(7).max(20).optional(),
});
