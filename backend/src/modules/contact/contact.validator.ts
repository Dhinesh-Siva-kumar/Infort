import { z } from 'zod';

// Mirrors the validation rules in the Angular ContactComponent form
// (frontend/src/app/components/contact/contact.component.ts) so both sides agree.
export const contactSchema = z.object({
  name: z.string().trim().min(3, 'Name must be at least 3 characters'),
  email: z.string().trim().email('Enter a valid email address'),
  phone: z.string().trim().regex(/^[0-9]{10}$/, 'Enter a valid 10 digit phone number'),
  service: z.string().trim().min(1, 'Please select a service'),
  message: z.string().trim().min(10, 'Message must be at least 10 characters').max(500),
});

export type ContactInput = z.infer<typeof contactSchema>;
