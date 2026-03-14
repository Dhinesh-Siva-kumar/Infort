import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavbarComponent } from '../../components/navbar/navbar.component';
import { HeroComponent } from '../../components/hero/hero.component';
import { AboutComponent } from '../../components/about/about.component';
import { ServicesComponent } from '../../components/services/services.component';
import { ErpComponent } from '../../components/erp/erp.component';
import { ProjectSupportComponent } from '../../components/project-support/project-support.component';
import { WhyChooseUsComponent } from '../../components/why-choose-us/why-choose-us.component';
import { TestimonialsComponent } from '../../components/testimonials/testimonials.component';
import { CtaComponent } from '../../components/cta/cta.component';
import { ContactComponent } from '../../components/contact/contact.component';
import { FooterComponent } from '../../components/footer/footer.component';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule,
    NavbarComponent,
    HeroComponent,
    AboutComponent,
    ServicesComponent,
    ErpComponent,
    ProjectSupportComponent,
    WhyChooseUsComponent,
    TestimonialsComponent,
    CtaComponent,
    ContactComponent,
    FooterComponent,
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {}
