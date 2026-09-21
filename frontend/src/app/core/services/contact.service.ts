import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ContactPayload, ContactResponse } from '../../shared/models/contact-payload.model';

@Injectable({
  providedIn: 'root'
})
export class ContactService {
  private readonly apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) {}

  sendContact(data: ContactPayload): Observable<ContactResponse> {
    return this.http.post<ContactResponse>(`${this.apiUrl}/contact`, data);
  }
}
