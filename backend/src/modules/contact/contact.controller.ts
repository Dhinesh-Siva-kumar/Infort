import { Request, Response } from 'express';
import { contactSchema } from './contact.validator';
import { ContactService } from './contact.service';
import { ValidationError } from '../../errors/AppError';

const contactService = new ContactService();

export async function submitContact(req: Request, res: Response): Promise<void> {
  const parsed = contactSchema.safeParse(req.body);

  if (!parsed.success) {
    throw new ValidationError('Please check the form and try again.', parsed.error.issues);
  }

  await contactService.submit(parsed.data);

  res.status(201).json({
    success: true,
    data: null,
    message: 'Thanks for reaching out! We will get back to you within 24 hours.',
  });
}
