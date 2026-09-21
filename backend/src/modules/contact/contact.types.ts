export interface ContactSubmission {
  id: number;
  name: string;
  email: string;
  phone: string;
  service: string;
  message: string;
  created_at: Date;
}

export type ContactSubmissionInput = Pick<
  ContactSubmission,
  'name' | 'email' | 'phone' | 'service' | 'message'
>;
