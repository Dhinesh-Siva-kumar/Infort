import { Component, HostListener, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.css'
})
export class NavbarComponent implements OnInit, OnDestroy {
  isScrolled = false;
  isMobileMenuOpen = false;
  activeSection = 'home';

  navLinks = [
    { label: 'Home', href: '#home' },
    { label: 'About', href: '#about' },
    { label: 'Services', href: '#services' },
    { label: 'ERP Solutions', href: '#erp' },
    { label: 'Why Choose Us', href: '#why-choose-us' },
    { label: 'Contact', href: '#contact' },
  ];

  private sectionObserver?: IntersectionObserver;

  ngOnInit(): void {
    const sections = this.navLinks
      .map(link => document.getElementById(link.href.replace('#', '')))
      .filter((el): el is HTMLElement => !!el);

    this.sectionObserver = new IntersectionObserver(
      entries => {
        const mostVisible = entries
          .filter(entry => entry.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
        if (mostVisible) {
          this.activeSection = mostVisible.target.id;
        }
      },
      { rootMargin: '-35% 0px -50% 0px', threshold: [0, 0.25, 0.5, 0.75, 1] }
    );

    sections.forEach(section => this.sectionObserver!.observe(section));
  }

  ngOnDestroy(): void {
    this.sectionObserver?.disconnect();
    document.body.style.overflow = '';
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 50;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
    document.body.style.overflow = this.isMobileMenuOpen ? 'hidden' : '';
  }

  closeMobileMenu() {
    this.isMobileMenuOpen = false;
    document.body.style.overflow = '';
  }

  scrollTo(href: string, event: Event) {
    event.preventDefault();
    const id = href.replace('#', '');
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    this.activeSection = id;
    this.closeMobileMenu();
  }

  navLinkClasses(link: { href: string }): string {
    const isActive = this.activeSection === link.href.replace('#', '');
    const base = 'px-4 py-2 rounded-lg text-sm transition-all duration-200';
    const weight = isActive ? 'font-semibold' : 'font-medium';

    if (this.isScrolled) {
      return isActive
        ? `${base} ${weight} text-red-600 bg-red-50`
        : `${base} ${weight} text-gray-700 hover:text-red-600 hover:bg-red-50`;
    }
    return isActive
      ? `${base} ${weight} text-white bg-white/15`
      : `${base} ${weight} text-white/90 hover:text-white hover:bg-white/10`;
  }

  mobileNavLinkClasses(link: { href: string }): string {
    const isActive = this.activeSection === link.href.replace('#', '');
    const base = 'px-4 py-3 rounded-xl text-sm transition-all duration-200 flex items-center gap-2';
    return isActive
      ? `${base} font-semibold text-red-600 bg-red-50`
      : `${base} font-medium text-gray-700 hover:text-red-600 hover:bg-red-50`;
  }
}
