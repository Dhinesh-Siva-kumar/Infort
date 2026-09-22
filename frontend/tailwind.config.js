/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        // Brand red/rose scale — the single source of truth for brand color.
        // Prefer these tokens (text-primary-600, bg-primary-50, ...) over raw
        // red-*/rose-* Tailwind defaults or hardcoded hex in new work.
        primary: {
          50: '#fff1f2',
          100: '#ffe4e6',
          200: '#fecdd3',
          300: '#fca5a5',
          400: '#f87171',
          500: '#ef4444',
          600: '#dc2626',
          700: '#b91c1c',
          800: '#991b1b',
          900: '#7f1d1d',
          950: '#450a0a',
        },
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        display: ['Sora', 'Inter', 'sans-serif'],
      },
      animation: {
        'fade-in': 'fadeIn 0.8s ease-in-out',
        'slide-up': 'slideUp 0.7s ease-out',
        'float': 'float 4s ease-in-out infinite',
        'pulse-slow': 'pulse 3s ease-in-out infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { opacity: '0', transform: 'translateY(40px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-15px)' },
        },
      },
      backgroundImage: {
        // Dark diagonal panel — hero, CTA section (full 4-stop drama).
        'hero-gradient': 'linear-gradient(135deg, #1c0505 0%, #450a0a 40%, #7f1d1d 70%, #b91c1c 100%)',
        // Darker closed-loop variant — ERP section's moodier enclosed panel.
        'erp-gradient': 'linear-gradient(135deg, #1c0505 0%, #450a0a 50%, #1c0505 100%)',
        // Subtle 2-stop variant — footer.
        'footer-gradient': 'linear-gradient(135deg, #1c0505 0%, #450a0a 100%)',
        // Solid brand fill for cards/badges on light backgrounds.
        'card-gradient': 'linear-gradient(135deg, #dc2626 0%, #be123c 100%)',
        // Light text-clip gradient for accent headline spans on dark sections.
        'text-gradient-light': 'linear-gradient(135deg, #fca5a5, #f87171, #dc2626)',
        // Bordered-panel accent gradient (About section visual frame).
        'card-border-gradient': 'linear-gradient(135deg, #991b1b, #7f1d1d, #b91c1c)',
      },
    },
  },
  plugins: [],
}
