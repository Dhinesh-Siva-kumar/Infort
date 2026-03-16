import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ContactService {
  private API_URL = 'http://localhost:3000';

  constructor(private http: HttpClient) {}

  sendContact(data: any): Observable<any> {
    return this.http.post(this.API_URL+'/contact', data);
  }

}
