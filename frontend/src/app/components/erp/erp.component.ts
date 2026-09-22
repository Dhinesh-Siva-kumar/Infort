import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-erp',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './erp.component.html',
  styleUrl: './erp.component.css'
})
export class ErpComponent {
  erpFeatures = [
    {
      icon: 'settings_suggest',
      title: 'Custom ERP Development',
      description: 'Tailor-made ERP systems built specifically for your business processes, industry needs, and growth plans.',
      gradient: 'from-primary-600 to-primary-800',
    },
    {
      icon: 'auto_mode',
      title: 'Business Process Automation',
      description: 'Automate repetitive tasks, streamline workflows, and eliminate manual errors to boost productivity significantly.',
      gradient: 'from-primary-600 to-primary-800',
    },
    {
      icon: 'inventory_2',
      title: 'Inventory Management',
      description: 'Real-time inventory tracking, smart reorder alerts, multi-location stock management, and supplier integration.',
      gradient: 'from-teal-600 to-emerald-600',
    },
    {
      icon: 'account_tree',
      title: 'Workflow Management',
      description: 'Design, automate, and optimize approval workflows, task assignments, and cross-department processes.',
      gradient: 'from-orange-500 to-amber-600',
    },
    {
      icon: 'show_chart',
      title: 'Analytics & Reporting',
      description: 'Real-time dashboards, KPI tracking, and detailed business intelligence reports to drive informed decisions.',
      gradient: 'from-pink-600 to-primary-600',
    },
    {
      icon: 'scale',
      title: 'Scalable Architecture',
      description: 'Cloud-ready, modular ERP architecture that grows with your business — from 10 to 10,000 users seamlessly.',
      gradient: 'from-orange-600 to-primary-600',
    },
  ];

  modules = ['HR & Payroll', 'CRM', 'Finance', 'Inventory', 'Sales', 'Procurement', 'Projects', 'Analytics'];
}

