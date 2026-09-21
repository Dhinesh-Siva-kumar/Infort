export interface ContactPayload {
  name: string;
  email: string;
  phone: string;
  service: string;
  message: string;
}

export interface ContactResponse {
  success: boolean;
  message: string;
}
