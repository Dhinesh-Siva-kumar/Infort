import { db } from '../../config/database';
import { User } from './user.types';

export class UserRepository {
  async findByEmail(email: string): Promise<User | undefined> {
    return db<User>('users').where({ email: email.toLowerCase() }).first();
  }

  async findById(id: number): Promise<User | undefined> {
    return db<User>('users').where({ id }).first();
  }

  async updateProfile(id: number, fields: Partial<Pick<User, 'name' | 'phone'>>): Promise<User> {
    const [row] = await db<User>('users')
      .where({ id })
      .update({ ...fields, updated_at: db.fn.now() })
      .returning('*');
    return row;
  }

  async updatePasswordHash(id: number, passwordHash: string): Promise<void> {
    await db<User>('users').where({ id }).update({ password_hash: passwordHash, updated_at: db.fn.now() });
  }
}
