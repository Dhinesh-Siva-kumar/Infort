import { ContactRepository, ContactListFilters } from './contact.repository';
import { ContactInput } from './contact.validator';
import { ContactStatus, ContactSubmission } from './contact.types';
import { Paginated } from '../../shared/pagination';
import { NotificationRepository } from '../notifications/notification.repository';
import { db } from '../../config/database';
import { NotFoundError } from '../../errors/AppError';

export class ContactService {
  constructor(
    private readonly repository: ContactRepository = new ContactRepository(),
    private readonly notifications: NotificationRepository = new NotificationRepository()
  ) {}

  async submit(input: ContactInput): Promise<ContactSubmission> {
    const submission = await this.repository.create(input);
    await this.notifyFounders(submission);
    return submission;
  }

  async list(filters: ContactListFilters): Promise<Paginated<ContactSubmission>> {
    return this.repository.findPaginated(filters);
  }

  async getById(id: number): Promise<ContactSubmission> {
    const submission = await this.repository.findById(id);
    if (!submission) {
      throw new NotFoundError('Contact request not found');
    }
    return submission;
  }

  async updateStatus(id: number, status: ContactStatus): Promise<ContactSubmission> {
    return this.repository.updateStatus(id, status);
  }

  private async notifyFounders(submission: ContactSubmission): Promise<void> {
    const founders = await db('users').where({ role: 'FOUNDER', is_active: true }).select('id');

    await Promise.all(
      founders.map((founder: { id: number }) =>
        this.notifications.create({
          userId: founder.id,
          type: 'CONTACT_REQUEST_CREATED',
          title: 'New Contact Request',
          body: `${submission.name} sent a new contact request (${submission.service}).`,
          contactSubmissionId: submission.id,
        })
      )
    );
  }
}
