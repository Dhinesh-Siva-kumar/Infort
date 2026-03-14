/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#fff1f2',
          100: '#ffe4e6',
          400: '#fb7185',
          500: '#f43f5e',
          600: '#dc2626',
          700: '#b91c1c',
          800: '#991b1b',
          900: '#7f1d1d',
        },
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
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
        'hero-gradient': 'linear-gradient(135deg, #1c0505 0%, #450a0a 40%, #7f1d1d 70%, #9f1239 100%)',
        'card-gradient': 'linear-gradient(135deg, #dc2626 0%, #be123c 100%)',
        'cta-gradient': 'linear-gradient(135deg, #dc2626 0%, #be123c 100%)',
      },
    },
  },
  plugins: [],
}
