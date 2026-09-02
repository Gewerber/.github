# UI/UX Improvement Plan — gewerber-app

Status: proposed
Date: 2026-09-02
Scope: `gewerber-app` (OSS) + `.github/brand` assets

## Why

The app is functional and the theme foundation (Material 3, Inter + Roboto Mono via
`google_fonts`, spacing/radius tokens) is solid — but the interface reads as flat and
utilitarian. This plan upgrades the visual layer toward the Brand Book v1.0 identity
(Clarity, Trust, Warmth) without touching business logic or the open-core boundary.

## Diagnosis (current state)

1. **No depth language.** `SectionCard` renders at elevation 0 at rest (hover → 2, and
   only when tappable). `GewerberTokens` has no elevation/shadow tokens at all; shadows
   are not a design mechanism anywhere in the app.
2. **Default Material instead of brand components.** Buttons, text fields, dialogs and
   navigation use stock M3 styling. Brand colors (Gewerber Blue `#2D6CDF`, Mint
   `#4CD4A9`) appear only in the `ColorScheme`.
3. **Off-brand iconography.** Default Material icons are used throughout
   (`Icons.receipt_long_outlined`, `Icons.timer_outlined`, …) while Brand Book §7
   specifies rounded, 2px-stroke iconography. This is the most visible brand gap.
4. **Weak typographic hierarchy.** Card titles use `titleMedium`; empty states are a
   single muted `Text` line with no call to action; key numbers get no display treatment
   and no tabular figures.
5. **Motion is nearly absent.** `flutter_animate` is used in only five places (splash,
   auth success view, password strength meter, auth error banner, staggered list item).
   No page transitions, no card/chart entrance animation. Auth screens are the most
   "alive" part of the app; everything else is static.
6. **Basic data visualization & states.** `MonthBarChart` is a plain `CustomPaint` with
   no grow-in animation and no hover tooltip on web. `ShimmerLoader` renders generic
   lines rather than the shape of the incoming content.

## Phases

### Phase 0 — Foundations (tokens + spec)

- Fill in `.github/brand/guidelines/` (currently empty): UI Kit spec covering depth /
  elevation scale, shadow recipes, motion rules and iconography rules, derived from
  Brand Book v1.0.
- Extend `GewerberTokens`: elevation scale (e.g. e1/e2/e3), shadow color token
  (translucent slate instead of pure black in light theme), motion tokens
  (durations 150/250/400 ms + curves).
- `GewerberColors`: add tonal tints (~12–15% opacity) for success/warning/error for use
  in badges and delta chips.

Acceptance: `dart analyze` clean; tokens documented in the UI Kit spec.

### Phase 1 — UI Kit core (the main "flatness" fix)

- `SectionCard` v2: resting elevation e1 + soft shadow, hover lift to e3, header with
  icon chip, empty state = icon + text + CTA button instead of a plain line.
- Buttons: brand styles via `ButtonStyle` in the theme (filled = Gewerber Blue, tonal =
  mint tint); loading state with spinner for async actions.
- Text fields: focus ring in brand color, prefix icons for amount/currency fields,
  consistent validation states.
- Badges/chips: tonal pill backgrounds instead of flat colored text.
- **Iconography swap** to rounded 2px-stroke icons (SVG assets + existing `flutter_svg`
  dependency, or an open-source set in the same style) behind a small `BrandIcon`
  wrapper so call sites stay tiny.
- Typography pass: overline for card headers, display for KPI numbers, tabular figures
  (`fontFeature: 'tnum'`, Roboto Mono for money); WCAG AA contrast check in both themes.

Acceptance: widget tests for kit components; visual check on web + mobile; screens that
consume the kit update through the theme automatically.

### Phase 2 — Screens (dashboard first)

- KPI cards: value + delta chip (success/error tints) + sparkline.
- Trends chart: staggered grow-in bar animation, hover tooltip on web, keep the existing
  screen-reader summary.
- Dashboard section entrance via the existing `StaggeredListItem`.
- Lists (customers / invoices / documents): consistent tile design, styled search field,
  filter chips, content-shaped shimmer skeletons instead of generic lines, empty states
  with CTA ("Create your first invoice").
- Forms (business profile, settings): section grouping with headers, inline validation,
  sticky save bar on web.
- `HomeShell`: logo at the top of the navigation rail, user card (avatar + name) at the
  bottom, content max-width (~1200 px) centered on wide web viewports.

### Phase 3 — Motion system

- Apply the global motion tokens from Phase 0; respect
  `MediaQuery.disableAnimations` / reduce-motion settings.
- Page transitions: custom transition in `go_router` (subtle fade + slide on web,
  shared-axis on mobile).
- Micro-interactions: press-scale and hover-lift promoted into the kit (the pattern
  already exists in `SectionCard`), generalize the auth success-check animation, styled
  snackbars/toasts.
- Loading standard: skeleton per widget type (card / row / chart); spinner reserved for
  long-running operations.

### Phase 4 — Dark mode & platform polish

- Dark pass: shadows do not read in dark theme → express elevation via border +
  surface-container steps; verify all new tints and shadows.
- Web: visible keyboard focus rings, hover states everywhere, pointer cursor on
  interactive elements.
- Mobile: animated bottom-nav indicator, touch targets ≥ 48 px, FAB for primary actions
  where appropriate.

### Phase 5 — QA & rollout

- `dart analyze` → `dart format .` → `flutter test`; widget tests for changed kit
  components; manual pass on Chrome + mobile; before/after screenshots per screen.
- Roll out module by module in small PRs: dashboard → lists → forms → auth refresh.

## Quick wins (highest impact, lowest effort)

1. Elevation + soft shadow in `SectionCard` — removes "flatness" across all screens at once.
2. Tonal badges and delta chips.
3. Brand icon set swap.
4. Staggered dashboard section entrance (component already exists).

## Constraints

- Open-core boundary: work stays in the OSS `gewerber-app`; no closed-module logic.
- Small composable widgets; reuse the shared UI Kit before adding new components.
- No business logic in the client (that belongs to `gewerber-backend`).
- No new dependencies required: `google_fonts`, `flutter_animate`, `shimmer` and
  `flutter_svg` are already in `pubspec.yaml`.

## Suggested order & rough effort

| Phase | Focus | Rough effort |
|---|---|---|
| 0 | Tokens + UI Kit spec | ~1 day |
| 1 | UI Kit components (depth, brand styles, icons) | ~3–5 days |
| 2 | Dashboard + key screens | ~3–5 days |
| 3 | Motion system | ~2 days |
| 4 | Dark mode + platform polish | ~1–2 days |
| 5 | QA & incremental rollout | ongoing |

Phases 0+1 deliver most of the visual improvement; Phase 2 can start in parallel once
the kit primitives are stable.
