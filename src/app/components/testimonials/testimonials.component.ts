import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-testimonials',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './testimonials.component.html',
  styleUrl: './testimonials.component.css'
})
export class TestimonialsComponent {
  testimonials = [
    {
      name: 'Arjun Mehta',
      role: 'CEO, TechVibe Startup',
      avatar: 'AM',
      avatarGradient: 'from-red-500 to-red-700',
      rating: 5,
      review: 'Infort completely transformed our digital presence. From our website redesign to our marketing campaigns, everything exceeded expectations. Their team is responsive, creative, and truly invested in your success.',
    },
    {
      name: 'Priya Sharma',
      role: 'Founder, GreenLeaf Organics',
      avatar: 'PS',
      avatarGradient: 'from-rose-500 to-rose-700',
      rating: 5,
      review: 'The ERP system Infort built for us automated 80% of our manual processes. Orders, inventory, invoicing — all in one place. The ROI was visible within the first month. Absolutely brilliant team!',
    },
    {
      name: 'Ravi Nair',
      role: 'Marketing Head, StyleCraft',
      avatar: 'RN',
      avatarGradient: 'from-teal-500 to-emerald-600',
      rating: 5,
      review: 'Working with Infort on our social media and content strategy was a game-changer. Our follower count tripled in 3 months and leads increased by 40%. They understand digital marketing at a deep level.',
    },
    {
      name: 'Divya Krishnan',
      role: 'Co-founder, EduSpark Platform',
      avatar: 'DK',
      avatarGradient: 'from-orange-500 to-amber-600',
      rating: 5,
      review: 'Infort developed our entire e-learning platform from scratch — backend, frontend, and mobile app. The quality was exceptional and they delivered 2 weeks ahead of schedule. Highly recommended!',
    },
    {
      name: 'Karan Patel',
      role: 'Director, SpeedLogix',
      avatar: 'KP',
      avatarGradient: 'from-rose-500 to-pink-600',
      rating: 5,
      review: 'The branding and logo work Infort did for us is stunning. They really understood our vision and translated it into a visual identity that stands out in the market. Professional and talented team.',
    },
    {
      name: 'Sneha Joshi',
      role: 'Entrepreneur, CloudCraft',
      avatar: 'SJ',
      avatarGradient: 'from-orange-500 to-red-600',
      rating: 5,
      review: 'From the initial consultation to post-launch support, Infort was with us every step. Their startup-friendly pricing and dedicated support make them the perfect tech partner for growing businesses.',
    },
  ];

  getStars(count: number): number[] {
    return Array(count).fill(0);
  }
}

