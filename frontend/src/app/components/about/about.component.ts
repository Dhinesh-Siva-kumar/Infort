import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-about',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './about.component.html',
  styleUrl: './about.component.css'
})
export class AboutComponent {
  values = [
    { icon: 'verified_user', label: 'Transparency' },
    { icon: 'workspace_premium', label: 'Quality' },
    { icon: 'bolt', label: 'Innovation' },
    { icon: 'handshake', label: 'Partnership' },
  ];

  badges = [
    'Software Development',
    'Website Development',
    'Digital Marketing',
    'ERP Solutions',
    'Brand Identity',
    '24/7 Support',
  ];
}
