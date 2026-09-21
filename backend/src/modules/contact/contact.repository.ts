import { db } from '../../config/database';
import { DatabaseError } from '../../errors/AppError';
import { ContactSubmission, ContactSubmissionInput } from './contact.types';

export class ContactRepository {
  async create(input: ContactSubmissionInput): Promise<ContactSubmission> {
    try {
      const [row] = await db('contact_submissions').insert(input).returning('*');
      return row as ContactSubmission;
    } catch (err) {
      console.error('[ContactRepository.create]', err);
      throw new DatabaseError('Could not save your message. Please try again.');
    }
  }
}
