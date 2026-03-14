import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-services',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './services.component.html',
  styleUrl: './services.component.css'
})
export class ServicesComponent {
  services = [
    {
      icon: 'trending_up',
      title: 'Digital Marketing',
      description: 'Data-driven marketing strategies — SEO, SEM, email campaigns, and analytics to grow your online presence and drive conversions.',
      gradient: 'from-red-500 to-orange-500',
      bg: 'from-red-50 to-orange-50',
      tags: ['SEO', 'SEM', 'Analytics'],
    },
    {
      icon: 'code',
      title: 'Web Development',
      description: 'Full-stack web applications built with modern frameworks — React, Angular, Node.js — optimized for performance and scalability.',
      gradient: 'from-rose-500 to-red-500',
      bg: 'from-rose-50 to-red-50',
      tags: ['Angular', 'React', 'Node.js'],
    },
    {
      icon: 'palette',
      title: 'Graphic Designing',
      description: 'Creative visual designs — UI/UX, banners, print materials, and digital assets that communicate your brand\'s story powerfully.',
      gradient: 'from-pink-500 to-rose-500',
      bg: 'from-pink-50 to-rose-50',
      tags: ['UI/UX', 'Print', 'Digital'],
    },
    {
      icon: 'diamond',
      title: 'Branding',
      description: 'Complete brand identity development — brand strategy, visual identity, voice & messaging to make your business unforgettable.',
      gradient: 'from-amber-500 to-orange-500',
      bg: 'from-amber-50 to-orange-50',
      tags: ['Identity', 'Strategy', 'Voice'],
    },
    {
      icon: 'groups',
      title: 'Social Media Handling',
      description: 'End-to-end social media management — content calendars, posting, engagement, and growth strategies across all platforms.',
      gradient: 'from-teal-500 to-emerald-500',
      bg: 'from-teal-50 to-emerald-50',
      tags: ['Instagram', 'LinkedIn', 'Facebook'],
    },
    {
      icon: 'edit_note',
      title: 'Content Writing',
      description: 'SEO-optimized, compelling content — blogs, website copy, ad copy, and product descriptions that drive traffic and conversions.',
      gradient: 'from-rose-600 to-red-600',
      bg: 'from-rose-50 to-red-50',
      tags: ['Blogs', 'SEO Copy', 'Ads'],
    },
    {
      icon: 'brush',
      title: 'Logo Creation',
      description: 'Professional, memorable logos and visual identity systems designed to make a lasting impression and reflect your brand essence.',
      gradient: 'from-red-500 to-pink-500',
      bg: 'from-red-50 to-pink-50',
      tags: ['Vector', 'Brand Kit', 'Icons'],
    },
  ];
}

