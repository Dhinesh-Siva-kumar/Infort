export const CONTACT_STATUSES = ['NEW', 'READ', 'IN_PROGRESS', 'REPLIED', 'CLOSED'] as const;
export type ContactStatus = (typeof CONTACT_STATUSES)[number];

export interface ContactSubmission {
  id: number;
  name: string;
  email: string;
  phone: string;
  service: string;
  message: string;
  status: ContactStatus;
  created_at: Date;
  updated_at: Date;
}

export type ContactSubmissionInput = Pick<
  ContactSubmission,
  'name' | 'email' | 'phone' | 'service' | 'message'
>;
