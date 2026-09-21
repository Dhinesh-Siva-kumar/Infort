export type UserRole = 'FOUNDER';

export interface User {
  id: number;
  name: string;
  email: string;
  password_hash: string;
  phone: string | null;
  role: UserRole;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
}

export type PublicUser = Omit<User, 'password_hash'>;

export function toPublicUser(user: User): PublicUser {
  const { password_hash, ...publicUser } = user;
  return publicUser;
}
