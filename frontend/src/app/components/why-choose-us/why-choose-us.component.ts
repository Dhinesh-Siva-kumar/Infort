import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-why-choose-us',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './why-choose-us.component.html',
  styleUrl: './why-choose-us.component.css'
})
export class WhyChooseUsComponent {
  reasons = [
  {
    icon: 'track_changes',
    title: 'Results-Driven Strategy',
    description: 'Every solution we build is aligned with your business goals — focusing on measurable growth, higher conversions, and long-term success.',
    gradient: 'from-primary-500 to-primary-700'
  },
  {
    icon: 'bolt',
    title: 'Fast & Reliable Delivery',
    description: 'Our agile workflow ensures projects move quickly without compromising quality, so you can launch faster and stay ahead of competitors.',
    gradient: 'from-orange-500 to-primary-500'
  },
  {
    icon: 'groups',
    title: 'Client-Centric Approach',
    description: 'We treat every project as a partnership — understanding your needs, communicating transparently, and delivering solutions that truly fit your business.',
    gradient: 'from-primary-500 to-pink-500'
  },
  {
    icon: 'hub',
    title: 'Integrated Digital Solutions',
    description: 'From web development and ERP systems to marketing and branding — we provide complete digital solutions under one roof.',
    gradient: 'from-primary-600 to-orange-600'
  },
  {
    icon: 'insights',
    title: 'Data & Performance Focused',
    description: 'We rely on analytics and insights to optimize strategies, helping you make smarter decisions and achieve sustainable growth.',
    gradient: 'from-pink-500 to-primary-500'
  },
  {
    icon: 'verified',
    title: 'Quality You Can Trust',
    description: 'With modern technologies, best practices, and strict quality standards, we deliver reliable solutions built for long-term performance.',
    gradient: 'from-amber-500 to-orange-500'
  }
];

  comparePoints = [
  { label: 'Dedicated Project Support', others: false },
  { label: 'Transparent Pricing', others: false },
  { label: 'End-to-End Digital Solutions', others: false },
  { label: 'Fast Project Delivery', others: true },
  { label: 'Modern Technology Stack', others: true },
  { label: 'Data-Driven Marketing', others: false },
  { label: 'Long-Term Partnership Focus', others: false }
];

  scrollTo(id: string) {
    const el = document.getElementById(id);
    if (el) el.scrollIntoView({ behavior: 'smooth' });
  }
}

