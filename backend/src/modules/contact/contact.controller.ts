import { Request, Response } from 'express';
import { contactSchema, contactListQuerySchema, updateStatusSchema } from './contact.validator';
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

export async function listContactRequests(req: Request, res: Response): Promise<void> {
  const parsed = contactListQuerySchema.safeParse(req.query);
  if (!parsed.success) {
    throw new ValidationError('Invalid query parameters.', parsed.error.issues);
  }

  const result = await contactService.list(parsed.data);

  res.json({
    success: true,
    data: result.items,
    message: 'OK',
    meta: { page: result.page, limit: result.limit, total: result.total },
  });
}

export async function getContactRequestsSummary(_req: Request, res: Response): Promise<void> {
  const summary = await contactService.summary();
  res.json({ success: true, data: summary, message: 'OK' });
}

export async function getContactRequest(req: Request, res: Response): Promise<void> {
  const submission = await contactService.getById(Number(req.params['id']));
  res.json({ success: true, data: submission, message: 'OK' });
}

export async function updateContactRequestStatus(req: Request, res: Response): Promise<void> {
  const parsed = updateStatusSchema.safeParse(req.body);
  if (!parsed.success) {
    throw new ValidationError('A valid status is required.', parsed.error.issues);
  }

  const submission = await contactService.updateStatus(Number(req.params['id']), parsed.data.status);
  res.json({ success: true, data: submission, message: 'Status updated' });
}
