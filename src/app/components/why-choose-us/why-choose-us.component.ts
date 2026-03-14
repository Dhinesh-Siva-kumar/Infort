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
      icon: 'rocket_launch',
      title: 'Startup-Friendly Solutions',
      description: 'We understand startups — lean budgets, fast pivots, and the need for scalable solutions from day one.',
      gradient: 'from-red-500 to-orange-500',
      delay: '0ms',
    },
    {
      icon: 'payments',
      title: 'Affordable Pricing',
      description: 'Flexible, transparent pricing plans with no hidden fees. Get enterprise-quality work at startup-friendly rates.',
      gradient: 'from-rose-500 to-red-500',
      delay: '100ms',
    },
    {
      icon: 'hub',
      title: 'All Services Under One Roof',
      description: 'No need to juggle multiple agencies. Get development, design, marketing, and ERP from one trusted partner.',
      gradient: 'from-teal-500 to-emerald-500',
      delay: '200ms',
    },
    {
      icon: 'groups',
      title: 'Experienced Team',
      description: 'Our specialists bring years of experience across domains — from Fortune 500 projects to successful product launches.',
      gradient: 'from-orange-500 to-amber-500',
      delay: '300ms',
    },
    {
      icon: 'speed',
      title: 'Fast Project Delivery',
      description: 'Agile sprints and a streamlined workflow mean you see results faster — without compromising on quality.',
      gradient: 'from-pink-500 to-rose-500',
      delay: '400ms',
    },
    {
      icon: 'support_agent',
      title: 'Dedicated Support',
      description: 'A dedicated account manager and support team that knows your project inside-out, available whenever you need.',
      gradient: 'from-rose-600 to-red-600',
      delay: '500ms',
    },
  ];

  comparePoints = [
    { label: 'Custom Solutions', us: true, others: false },
    { label: 'Startup-Friendly Pricing', us: true, others: false },
    { label: 'All-in-One Services', us: true, others: false },
    { label: '24/7 Dedicated Support', us: true, others: false },
    { label: 'Scalable Architecture', us: true, others: true },
    { label: 'Post-Launch Maintenance', us: true, others: false },
  ];
}

