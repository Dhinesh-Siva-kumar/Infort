import { ContactRepository } from './contact.repository';
import { ContactInput } from './contact.validator';
import { ContactSubmission } from './contact.types';

export class ContactService {
  constructor(private readonly repository: ContactRepository = new ContactRepository()) {}

  async submit(input: ContactInput): Promise<ContactSubmission> {
    return this.repository.create(input);
  }
}
