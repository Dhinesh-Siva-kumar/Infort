import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-hero',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './hero.component.html',
  styleUrl: './hero.component.css'
})
export class HeroComponent {
  stats = [
    { value: '20+', label: 'Projects Delivered' },
    { value: '10+', label: 'Happy Clients' },
    { value: '3+', label: 'Years Experience' },
    { value: '24/7', label: 'Support' },
  ];

  scrollTo(id: string) {
    const el = document.getElementById(id);
    if (el) el.scrollIntoView({ behavior: 'smooth' });
  }
}
