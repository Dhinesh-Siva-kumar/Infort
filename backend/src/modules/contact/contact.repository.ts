import { db } from '../../config/database';
import { DatabaseError, NotFoundError } from '../../errors/AppError';
import { Paginated } from '../../shared/pagination';
import { ContactStatus, ContactSubmission, ContactSubmissionInput } from './contact.types';

export interface ContactListFilters {
  page: number;
  limit: number;
  search?: string;
  status?: ContactStatus;
  sort: 'newest' | 'oldest';
}

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

  async findPaginated(filters: ContactListFilters): Promise<Paginated<ContactSubmission>> {
    const query = db<ContactSubmission>('contact_submissions');

    if (filters.status) {
      query.where({ status: filters.status });
    }

    if (filters.search) {
      const term = `%${filters.search.toLowerCase()}%`;
      query.andWhere((builder) => {
        builder
          .whereRaw('lower(name) like ?', [term])
          .orWhereRaw('lower(email) like ?', [term])
          .orWhereRaw('lower(phone) like ?', [term])
          .orWhereRaw('lower(service) like ?', [term]);
      });
    }

    const countQuery = query.clone();

    const items = await query
      .orderBy('created_at', filters.sort === 'oldest' ? 'asc' : 'desc')
      .limit(filters.limit)
      .offset((filters.page - 1) * filters.limit);

    const [{ count }] = await countQuery.count<{ count: string }[]>('id as count');

    return { items, page: filters.page, limit: filters.limit, total: Number(count) };
  }

  async findById(id: number): Promise<ContactSubmission | undefined> {
    return db<ContactSubmission>('contact_submissions').where({ id }).first();
  }

  async updateStatus(id: number, status: ContactStatus): Promise<ContactSubmission> {
    const [row] = await db<ContactSubmission>('contact_submissions')
      .where({ id })
      .update({ status, updated_at: db.fn.now() })
      .returning('*');

    if (!row) {
      throw new NotFoundError('Contact request not found');
    }

    return row;
  }

  async countsSummary(): Promise<{ total: number; newCount: number; todayCount: number; pendingCount: number }> {
    const [{ count: total }] = await db('contact_submissions').count<{ count: string }[]>('id as count');
    const [{ count: newCount }] = await db('contact_submissions')
      .where({ status: 'NEW' })
      .count<{ count: string }[]>('id as count');
    const [{ count: todayCount }] = await db('contact_submissions')
      .where('created_at', '>=', db.raw("date_trunc('day', now())"))
      .count<{ count: string }[]>('id as count');
    const [{ count: pendingCount }] = await db('contact_submissions')
      .whereIn('status', ['NEW', 'READ', 'IN_PROGRESS'])
      .count<{ count: string }[]>('id as count');

    return {
      total: Number(total),
      newCount: Number(newCount),
      todayCount: Number(todayCount),
      pendingCount: Number(pendingCount),
    };
  }
}
