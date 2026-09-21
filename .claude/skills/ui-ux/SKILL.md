---
name: ui-ux
description: Use whenever adding or changing UI in this Angular/Tailwind marketing site (components, pages, sections, buttons, cards) — enforces this project's design system (colors, typography, spacing, motion, accessibility) so new work matches the existing look instead of drifting.
---

# Infort UI/UX Design System

This is a marketing/landing site (Angular 19 + Tailwind CSS). Follow these
conventions for any new or edited UI so it stays visually consistent with the
rest of the site.

## Typography

- Body text: **Inter** (`font-sans`, the Tailwind default here).
- Headings (`h1`–`h6`) and display numbers/stats: **Sora** (`font-display`).
- Both are loaded via Google Fonts in `frontend/src/index.html` — if you add
  new weights, update that `<link>` and keep `frontend/tailwind.config.js`
  `theme.extend.fontFamily` in sync.
- Prefer `font-bold` (700) for headings. Avoid `font-black` (900) and
  negative `tracking-tight*` on large headings — the site intentionally
  moved away from that because it read as too sharp/aggressive. Normal or
  slightly tight tracking only.
- Reuse the existing utility classes instead of one-off styles:
  - `.section-title` — big centered section heading.
  - `.section-subtitle` — muted subheading under a section title.
  - `.gradient-text` — brand gradient text clip.

## Color

Defined in `frontend/tailwind.config.js` under `theme.extend.colors.primary`
(a red/rose scale, 50→900) and `backgroundImage` (`hero-gradient`,
`card-gradient`, `cta-gradient`, all `#dc2626 → #be123c`-style diagonals).

- Use the `primary` scale and existing gradients rather than introducing new
  hex colors. If a new shade is truly needed, add it to the Tailwind config
  rather than hardcoding hex in a template.
- Base text color on light sections: `text-gray-900` (headings),
  `text-gray-500`/`text-gray-600` (body/subtext) — matches `body { color:
  #1e293b }` in `frontend/src/styles.css`.
- Dark sections (hero, CTA, ERP) use white text over the red gradient
  backgrounds.

## Buttons

Use the existing `.btn-gradient` (primary CTA) and `.btn-outline` (secondary,
on dark backgrounds) classes from `frontend/src/styles.css` instead of
rebuilding button styles per-component. Both already include hover/active
transforms, shadow, and icon-shift-on-hover behavior via `.material-icons`.

## Cards & Sections

- Section vertical rhythm: `.section-padding` (`py-20 px-4 sm:px-6 lg:px-16`).
- Card hover lift: `.service-card:hover` / `.card-hover-brand:hover` patterns
  (translateY + brand-tinted shadow) — reuse rather than inventing new hover
  treatments.

## Motion

Reuse the existing keyframes/utilities instead of adding new ones:
`animate-fade-in`, `animate-slide-up`, `animate-float`
(`fadeIn`/`slideUp`/`float` in `frontend/src/styles.css` and
`frontend/tailwind.config.js`). All motion must respect
`prefers-reduced-motion` — the global rule in `frontend/src/styles.css`
already disables float/bounce/pulse for reduced-motion users; extend that
block if you add new looping animations.

## Accessibility

- Keep the global `:focus-visible` outline (red, 2px, offset) working on any
  new interactive element — don't add `outline: none` without a visible
  replacement.
- Maintain sufficient contrast: don't put gray-500 text on the red gradient
  backgrounds, don't put white text below ~AA contrast on light backgrounds.
- Icons (Material Icons / Font Awesome, both loaded in `index.html`) are
  decorative next to text labels — don't rely on an icon alone to convey
  meaning.

## Workflow

1. Reuse an existing class/pattern from `frontend/src/styles.css` before
   writing new CSS.
2. If a genuinely new pattern is needed, add it to `frontend/src/styles.css`
   (or `frontend/tailwind.config.js` for tokens) rather than inlining
   one-off styles in a single component, so it's reusable and stays
   on-brand.
3. After any visual change, run `cd frontend && npx ng build
   --configuration=development` to confirm the app still compiles.
