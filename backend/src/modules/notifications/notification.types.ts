export interface Notification {
  id: number;
  user_id: number;
  type: string;
  title: string;
  body: string;
  contact_submission_id: number | null;
  read_at: Date | null;
  created_at: Date;
}
