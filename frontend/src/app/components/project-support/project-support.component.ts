import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-project-support',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './project-support.component.html',
  styleUrl: './project-support.component.css'
})
export class ProjectSupportComponent {
  steps = [
    {
      step: '01',
      icon: 'search',
      title: 'Requirement Analysis',
      description: 'We dive deep into your business goals, challenges, and vision to build a complete understanding of what you need.',
      gradient: 'from-primary-500 to-primary-700',
      lightBg: 'bg-primary-50',
      textColor: 'text-primary-600',
    },
    {
      step: '02',
      icon: 'map',
      title: 'Planning & Strategy',
      description: 'Our team creates a detailed project roadmap, technology stack selection, timelines, and resource allocation plan.',
      gradient: 'from-primary-500 to-primary-700',
      lightBg: 'bg-primary-50',
      textColor: 'text-primary-600',
    },
    {
      step: '03',
      icon: 'construction',
      title: 'Development',
      description: 'Agile sprint-based development with regular demos, code reviews, and transparent progress tracking throughout.',
      gradient: 'from-primary-600 to-primary-800',
      lightBg: 'bg-primary-50',
      textColor: 'text-primary-700',
    },
    {
      step: '04',
      icon: 'rocket_launch',
      title: 'Deployment',
      description: 'Rigorous QA testing followed by smooth, zero-downtime deployment with full monitoring and launch support.',
      gradient: 'from-teal-500 to-teal-700',
      lightBg: 'bg-teal-50',
      textColor: 'text-teal-600',
    },
    {
      step: '05',
      icon: 'support_agent',
      title: 'Maintenance & Support',
      description: 'Ongoing technical support, performance optimization, feature updates, and 24/7 monitoring post-launch.',
      gradient: 'from-green-500 to-green-700',
      lightBg: 'bg-green-50',
      textColor: 'text-green-600',
    },
  ];

  scrollTo(id: string) {
    const el = document.getElementById(id);
    if (el) el.scrollIntoView({ behavior: 'smooth' });
  }
}

