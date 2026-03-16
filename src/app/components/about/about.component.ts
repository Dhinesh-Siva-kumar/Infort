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
  features = [
    { icon: 'handshake', title: 'End-to-End Project Handling', desc: 'From requirements gathering to deployment and maintenance, we manage your project completely.' },
    { icon: 'verified', title: 'Reliable Digital Solutions', desc: 'We deliver robust, scalable solutions built with the latest technologies and best practices.' },
    { icon: 'track_changes', title: 'Customer-Focused Approach', desc: 'Your goals are our goals. We align every strategy with your business objectives.' },
    { icon: 'support_agent', title: 'Dedicated Support', desc: '24/7 support team ready to assist you with any technical or strategic challenges.' },
    { icon: 'rocket_launch', title: 'Scale Digitally', desc: 'We help startups and growing businesses build their digital presence and scale fast.' },
    { icon: 'payments', title: 'Affordable Pricing', desc: 'Startup-friendly pricing models that deliver maximum value without breaking your budget.' },
  ];
}
