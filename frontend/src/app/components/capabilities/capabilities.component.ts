import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-capabilities',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './capabilities.component.html',
  styleUrl: './capabilities.component.css'
})
export class CapabilitiesComponent {
  features = [
    { icon: 'handshake', title: 'End-to-End Project Handling', desc: "From the first requirements call to deployment and ongoing maintenance, one team owns the entire project." },
    { icon: 'event_available', title: 'Clear Milestones & Timelines', desc: "Every project ships in defined phases with agreed checkpoints, so you always know what's next and when." },
    { icon: 'contact_support', title: 'One Dedicated Point of Contact', desc: 'A single person coordinates your project — no bouncing between departments or chasing updates.' },
    { icon: 'support_agent', title: 'Support After Launch', desc: '24/7 support team ready to assist with any technical or strategic challenge, long after go-live.' },
    { icon: 'tune', title: 'Flexible Engagement', desc: 'Project-based, retainer, or sprint-by-sprint — we adapt how we work to fit how your business operates.' },
    { icon: 'receipt_long', title: 'Transparent, Upfront Quotes', desc: 'Fixed pricing agreed before work begins — no hidden fees, no surprise invoices.' },
  ];

  scrollTo(id: string) {
    const el = document.getElementById(id);
    if (el) el.scrollIntoView({ behavior: 'smooth' });
  }
}
