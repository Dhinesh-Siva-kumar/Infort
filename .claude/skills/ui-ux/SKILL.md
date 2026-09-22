---
name: ui-ux
description: Use whenever adding or changing UI in this Angular/Tailwind marketing site (components, pages, sections, buttons, cards) — brings senior UI/UX designer judgement (hierarchy, whitespace, contrast, conversion flow, accessibility) AND enforces this project's design system (colors, typography, spacing, motion) so new work matches the existing look instead of drifting.
---

# Infort UI/UX — Design Expertise + Design System

This is a marketing/landing site (Angular 19 + Tailwind CSS). When touching
UI, act as a senior product designer would: judge the work on hierarchy,
clarity, and conversion — not just "does it use the right class name." Then
apply the project's concrete design-system rules below so the result matches
the rest of the site.

## Design judgement (apply before writing any markup)

A senior designer asks these questions before shipping a section. Run
through them for anything new, and when reviewing/improving existing UI:

1. **What's the one thing this section wants the visitor to notice first?**
   If everything is bold/colored/boxed, nothing stands out. Pick one visual
   anchor per section (usually the headline or the primary CTA) and let
   everything else recede — smaller type, muted color, less contrast.
2. **Does the layout breathe?** Cramped spacing reads as cheap; generous
   whitespace reads as premium. When in doubt, add space around a group
   before adding another visual element inside it. Prefer removing a
   competing element over shrinking spacing to fit more in.
3. **Is there a redundant or competing section?** Before adding new content,
   check whether an existing section already says it (this project has
   caught real duplication between "About," "Why Choose Us," and
   "Capabilities" — don't reintroduce it). Cut or consolidate rather than
   stack near-duplicate pitches.
4. **Would a first-time visitor understand this in 3 seconds?** Prefer one
   clear sentence over three qualifying clauses. Prefer a short label over a
   paragraph. If a section needs a long explanation to make sense, the
   layout is probably doing too much.
5. **Is contrast doing its job?** Contrast should mark what's important
   (headline vs. body, primary CTA vs. secondary), not just look "colorful."
   Two buttons of equal visual weight fight each other — one should always
   read as primary.
6. **Mobile-first, not "shrunk desktop."** Check how a section collapses at
   `sm`/mobile widths, not just how it looks at `lg`. A grid that reflows
   awkwardly, a table that just scrolls horizontally, or a hover-only
   affordance with no mobile equivalent are all real regressions, not edge
   cases.
7. **Does motion earn its place?** Hover lift/shadow, icon shifts, and fades
   are fine in small doses; if a section has five different animated
   elements competing at once, cut it back. Motion should draw the eye to
   one thing, not everywhere at once.

If a change fails one of these, say so and propose the fix — don't just
implement whatever was literally asked if it visibly conflicts with these
principles; flag the tension briefly and apply the better version.

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
(a full red/rose scale, 50→950 — this is the single source of truth for
brand color; prefer `primary-*` over raw `red-*`/`rose-*` in new work) and
`backgroundImage`:
- `hero-gradient` — dark diagonal panel (hero, CTA section).
- `erp-gradient` — darker closed-loop variant (ERP section only).
- `footer-gradient` — subtler 2-stop variant (footer only).
- `card-gradient` — solid brand fill for cards/badges on light backgrounds
  (`#dc2626 → #be123c`).
- `text-gradient-light` — light red text-clip gradient for accent headline
  spans on dark sections.
- `card-border-gradient` — bordered-panel accent gradient (About section
  visual frame).

- Use these tokens rather than introducing new hex colors or duplicating an
  existing gradient's raw values inline. If a new shade/gradient is truly
  needed, add it to `tailwind.config.js` rather than hardcoding hex in a
  template — this project has twice had to clean up hardcoded, drifted
  duplicates of the same gradient scattered across components.
- Stay strictly within the red/rose family for brand elements — don't mix in
  orange/pink/amber for anything meant to read as "Infort brand," even as a
  gradient endpoint. Orange/pink/teal etc. are fine only for genuinely
  decorative per-item variety (e.g. distinguishing service category icons),
  never for brand-identity elements (logo-adjacent gradients, primary CTAs).
- Base text color on light sections: `text-gray-900` (headings),
  `text-gray-500`/`text-gray-600` (body/subtext) — matches `body { color:
  #1e293b }` in `frontend/src/styles.css`.
- Dark sections (hero, CTA, ERP, footer) use white text over the red
  gradient backgrounds.

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
- **Decorative icons**: every purely-decorative `material-icons`/`<i
  class="fa...">` span (an icon sitting next to text that already conveys
  the meaning) must get `aria-hidden="true"`. This project had a sitewide
  gap here that was swept once already — don't reintroduce it in new
  components. An icon that conveys meaning on its own (e.g. a check/X in a
  comparison table, a star rating) needs a real text alternative
  (`sr-only` span or `aria-label`), not just `aria-hidden`.
- **Forms**: every `<label>` needs a matching `for`/`id` pair with its
  control — don't rely on visual proximity alone. Required fields need
  `aria-required="true"`; invalid-and-touched fields need `aria-invalid`
  and `aria-describedby` pointing at the error message's `id`. Success/error
  state changes that replace content should be wrapped in `aria-live`.
- **Toggled overlays** (mobile menus, dropdowns, modals): the trigger button
  needs `aria-expanded` bound to open state and `aria-controls` pointing at
  the panel's `id`. Support `Escape` to close and click-outside-to-close —
  see `navbar.component.ts`'s `onEscapeKey`/`onDocumentClick` for the
  established pattern (`@HostListener('document:keydown.escape')` /
  `@HostListener('document:click', ['$event'])` with an injected
  `ElementRef` containment check).
- Every page needs exactly one skip-to-content link before the nav, pointing
  at `<main id="main-content">` — already present in `home.component.html`;
  keep it if you restructure the page shell.

## Workflow

1. Reuse an existing class/pattern from `frontend/src/styles.css` before
   writing new CSS.
2. If a genuinely new pattern is needed, add it to `frontend/src/styles.css`
   (or `frontend/tailwind.config.js` for tokens) rather than inlining
   one-off styles in a single component, so it's reusable and stays
   on-brand.
3. After any visual change, run `cd frontend && npx ng build
   --configuration=development` to confirm the app still compiles.

## Before calling a section done

Quick pass a senior designer would run before handing work back:

- [ ] One clear visual anchor per section — not three competing focal points.
- [ ] No section says the same thing another section already says.
- [ ] Headline + subtitle readable and make sense in under 3 seconds.
- [ ] Spacing is generous, not cramped — nothing touching card edges awkwardly.
- [ ] Checked at mobile width, not just desktop.
- [ ] All decorative icons `aria-hidden`; all meaningful icons have text alternatives.
- [ ] Colors pulled from `primary-*`/existing gradient tokens, not new hex.
- [ ] `ng build --configuration=development` passes clean.
