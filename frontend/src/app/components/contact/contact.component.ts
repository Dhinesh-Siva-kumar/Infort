import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ContactService } from '../../core/services/contact.service';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  templateUrl: './contact.component.html',
  styleUrl: './contact.component.css'
})
export class ContactComponent {
  contactForm!: FormGroup;
  isSubmitting = false;
  isSubmitted = false;
  submitError: string | null = null;

  contactInfo = [
    { icon: 'email', label: 'Email Us', value: 'infortsolutions@infort.in', href: 'mailto:infortsolutions@infort.in', color: 'from-blue-500 to-blue-700' },
    { icon: 'phone', label: 'Call Us', value: '+91 6383944767', href: 'tel:+916383944767', color: 'from-purple-500 to-purple-700' },
    { icon: 'location_on', label: 'Visit Us', value: 'Trichy, India', href: '#', color: 'from-teal-500 to-teal-700' },
    { icon: 'access_time', label: 'Working Hours', value: 'Mon–Sat: 9AM – 7PM', href: '#', color: 'from-orange-500 to-orange-700' },
  ];

  socialLinks = [
    { icon: 'fab fa-linkedin-in', href: '#', label: 'LinkedIn', gradient: 'from-blue-600 to-blue-800' },
    { icon: 'fab fa-instagram', href: '#', label: 'Instagram', gradient: 'from-pink-500 to-purple-600' },
    { icon: 'fab fa-twitter', href: '#', label: 'Twitter', gradient: 'from-sky-400 to-blue-500' },
    { icon: 'fab fa-facebook-f', href: '#', label: 'Facebook', gradient: 'from-blue-600 to-indigo-700' },
    { icon: 'fab fa-whatsapp', href: '#', label: 'WhatsApp', gradient: 'from-green-500 to-emerald-600' },
  ];

  constructor(private fb: FormBuilder,
    private contactService: ContactService
  ) {
  }

  ngOnInit(): void {
    this.initForm();
  }

  initForm() {
    this.contactForm = this.fb.group({
      name: ['', [
        Validators.required,
        Validators.minLength(3)
      ]],

      email: ['', [
        Validators.required,
        Validators.email
      ]],

      phone: ['', [
  Validators.required,
  Validators.pattern('^[0-9]{10}$')
]],

      service: ['', Validators.required],

      message: ['', [
        Validators.required,
        Validators.minLength(10),
        Validators.maxLength(500)
      ]]
    });
  }


  get f() { return this.contactForm.controls; }

  onSubmit() {

    if (this.contactForm.invalid) {
      this.contactForm.markAllAsTouched();
      return;
    }

    this.isSubmitting = true;
    this.submitError = null;

    this.contactService.sendContact(this.contactForm.value)
      .subscribe({
        next: () => {
          this.isSubmitting = false;
          this.isSubmitted = true;
        },
        error: (err) => {
          this.isSubmitting = false;
          this.submitError = 'Something went wrong while sending your message. Please try again or contact us directly.';
          console.error(err);
        }
      });
  }

  resetForm() {
    this.contactForm.reset();
    this.isSubmitted = false;
    this.submitError = null;
  }
}
