import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  templateUrl: './contact.component.html',
  styleUrl: './contact.component.css'
})
export class ContactComponent {
  contactForm: FormGroup;
  isSubmitting = false;
  isSubmitted = false;

  contactInfo = [
    { icon: 'email', label: 'Email Us', value: 'hello@infort.in', href: 'mailto:hello@infort.in', color: 'from-blue-500 to-blue-700' },
    { icon: 'phone', label: 'Call Us', value: '+91 98765 43210', href: 'tel:+919876543210', color: 'from-purple-500 to-purple-700' },
    { icon: 'location_on', label: 'Visit Us', value: 'Bengaluru, Karnataka, India', href: '#', color: 'from-teal-500 to-teal-700' },
    { icon: 'access_time', label: 'Working Hours', value: 'Mon–Sat: 9AM – 7PM', href: '#', color: 'from-orange-500 to-orange-700' },
  ];

  socialLinks = [
    { icon: 'fab fa-linkedin-in', href: '#', label: 'LinkedIn', gradient: 'from-blue-600 to-blue-800' },
    { icon: 'fab fa-instagram', href: '#', label: 'Instagram', gradient: 'from-pink-500 to-purple-600' },
    { icon: 'fab fa-twitter', href: '#', label: 'Twitter', gradient: 'from-sky-400 to-blue-500' },
    { icon: 'fab fa-facebook-f', href: '#', label: 'Facebook', gradient: 'from-blue-600 to-indigo-700' },
    { icon: 'fab fa-whatsapp', href: '#', label: 'WhatsApp', gradient: 'from-green-500 to-emerald-600' },
  ];

  constructor(private fb: FormBuilder) {
    this.contactForm = this.fb.group({
      name: ['', [Validators.required, Validators.minLength(2)]],
      email: ['', [Validators.required, Validators.email]],
      phone: [''],
      service: [''],
      message: ['', [Validators.required, Validators.minLength(10)]],
    });
  }

  get f() { return this.contactForm.controls; }

  onSubmit() {
    if (this.contactForm.invalid) {
      this.contactForm.markAllAsTouched();
      return;
    }
    this.isSubmitting = true;
    setTimeout(() => {
      this.isSubmitting = false;
      this.isSubmitted = true;
      this.contactForm.reset();
    }, 1500);
  }

  resetForm() {
    this.isSubmitted = false;
  }
}
