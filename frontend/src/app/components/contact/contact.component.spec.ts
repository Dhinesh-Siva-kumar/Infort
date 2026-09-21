import { ComponentFixture, TestBed } from '@angular/core/testing';
import { of, throwError } from 'rxjs';
import { ContactComponent } from './contact.component';
import { ContactService } from '../../core/services/contact.service';
import { ContactResponse } from '../../shared/models/contact-payload.model';

describe('ContactComponent', () => {
  let component: ContactComponent;
  let fixture: ComponentFixture<ContactComponent>;
  let contactServiceSpy: jasmine.SpyObj<ContactService>;

  const validForm = {
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '9876543210',
    service: 'web-development',
    message: 'This is a message that is definitely long enough.',
  };

  beforeEach(async () => {
    contactServiceSpy = jasmine.createSpyObj<ContactService>('ContactService', ['sendContact']);

    await TestBed.configureTestingModule({
      imports: [ContactComponent],
      providers: [{ provide: ContactService, useValue: contactServiceSpy }],
    }).compileComponents();

    fixture = TestBed.createComponent(ContactComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create with an invalid, untouched form', () => {
    expect(component).toBeTruthy();
    expect(component.contactForm.invalid).toBeTrue();
  });

  describe('validation', () => {
    it('requires name to be at least 3 characters', () => {
      const name = component.f['name'];
      name.setValue('Jo');
      expect(name.invalid).toBeTrue();
      name.setValue('Joe');
      expect(name.valid).toBeTrue();
    });

    it('requires a valid email', () => {
      const email = component.f['email'];
      email.setValue('not-an-email');
      expect(email.invalid).toBeTrue();
      email.setValue('valid@example.com');
      expect(email.valid).toBeTrue();
    });

    it('requires a 10 digit phone number', () => {
      const phone = component.f['phone'];
      phone.setValue('12345');
      expect(phone.hasError('pattern')).toBeTrue();
      phone.setValue('9876543210');
      expect(phone.valid).toBeTrue();
    });

    it('requires message to be between 10 and 500 characters', () => {
      const message = component.f['message'];
      message.setValue('short');
      expect(message.hasError('minlength')).toBeTrue();
      message.setValue('a'.repeat(501));
      expect(message.hasError('maxlength')).toBeTrue();
      message.setValue('this message is long enough');
      expect(message.valid).toBeTrue();
    });
  });

  describe('onSubmit', () => {
    it('does not call the service and marks fields touched when the form is invalid', () => {
      component.onSubmit();

      expect(contactServiceSpy.sendContact).not.toHaveBeenCalled();
      expect(component.f['name'].touched).toBeTrue();
    });

    it('sets isSubmitted on a successful send', () => {
      contactServiceSpy.sendContact.and.returnValue(
        of<ContactResponse>({ success: true, message: 'ok' })
      );
      component.contactForm.setValue(validForm);

      component.onSubmit();

      expect(contactServiceSpy.sendContact).toHaveBeenCalledWith(validForm);
      expect(component.isSubmitting).toBeFalse();
      expect(component.isSubmitted).toBeTrue();
      expect(component.submitError).toBeNull();
    });

    it('surfaces a user-visible error when the send fails', () => {
      contactServiceSpy.sendContact.and.returnValue(throwError(() => new Error('network error')));
      component.contactForm.setValue(validForm);

      component.onSubmit();

      expect(component.isSubmitting).toBeFalse();
      expect(component.isSubmitted).toBeFalse();
      expect(component.submitError).toContain('Something went wrong');
    });
  });

  describe('resetForm', () => {
    it('clears submitted/error state and the form value', () => {
      component.contactForm.setValue(validForm);
      component.isSubmitted = true;
      component.submitError = 'some error';

      component.resetForm();

      expect(component.isSubmitted).toBeFalse();
      expect(component.submitError).toBeNull();
      expect(component.contactForm.value.name).toBeNull();
    });
  });
});
