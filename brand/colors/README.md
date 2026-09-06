# Brand Colors

This folder contains the Gewerber color palette in multiple formats for different platforms and tools.

## Files

| File | Format | Use Case |
|------|--------|----------|
| `colors.json` | JSON | Programmatic access, design tools, Style Dictionary |
| `colors.css` | CSS Custom Properties | Web projects, HTML/CSS/JS |
| `_colors.scss` | SCSS Variables | Sass/SCSS projects, Flutter Web |
| `colors.dart` | Dart/Flutter | Flutter mobile, web, desktop apps |
| `tokens.json` | Design Tokens (Style Dictionary) | Design systems, Figma tokens, multi-platform |

## Color Palette

| Role | Name | Hex | Usage |
|------|------|-----|-------|
| Primary | Gewerber Blue | `#2D6CDF` | Primary actions, links, brand elements |
| Accent | Gewerber Mint | `#4CD4A9` | Highlights, decorative accents (containers only — not text) |
| Background | Soft Gray | `#F5F7FA` | Page background |
| Surface | White | `#FFFFFF` | Cards, modals, inputs |
| Text | Deep Slate | `#1F2A33` | Primary text content |
| Text Secondary | | `#5A6A78` | Supporting text |
| Text Muted | | `#64707E` | Placeholders, disabled text (v1.1: contrast ≥ 4.5:1) |
| Border | | `#E1E5EB` | Dividers, input borders |
| Error | Red | `#CC3333` | Errors, destructive actions (v1.1: contrast ≥ 4.5:1) |
| Success | Green | `#187F4F` | Success states, positive actions (v1.1: contrast ≥ 4.5:1) |
| Warning | Amber | `#996200` | Warnings, caution (v1.1: contrast ≥ 4.5:1) |
| Info | Blue | `#2D6CDF` | Information, help |

> **v1.1 contrast revision (2026-09)**: Error, Success, Warning, Text Muted and Accent Dark were deepened so that every token used as text passes WCAG AA (≥ 4.5:1) and every token used as essential UI passes ≥ 3:1 — on White **and** on the `#F5F7FA` background. The previous values (`#E54848`, `#3BB273`, `#F5A623`, `#9AA5B1`, `#2DB387`) failed on both surfaces and are retired. Decorative/container colors (Accent Mint, the `*Light` variants, Primary) are unchanged. Machine-checked thresholds: `gewerber-app/test/core/theme/contrast_test.dart`.

## Usage Examples

### CSS
```css
.button-primary {
  background-color: var(--color-primary);
  color: var(--color-text-inverse);
}
.button-primary:hover {
  background-color: var(--color-primary-hover);
}
```

### SCSS
```scss
@use 'colors' as *;

.button-primary {
  background-color: $color-primary;
  color: $color-text-inverse;
  &:hover {
    background-color: $color-primary-hover;
  }
}
```

### Dart/Flutter
```dart
import 'colors.dart';

Container(
  color: GewerberColors.primary,
  child: Text('Primary', style: TextStyle(color: GewerberColors.textInverse)),
)

// Or use MaterialColor swatches in ThemeData
ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: GewerberColors.primarySwatch,
    accentColor: GewerberColors.accentSwatch,
  ),
)
```

### Design Tokens (Style Dictionary)
```bash
# Install Style Dictionary
npm install -g style-dictionary

# Build tokens for platforms
style-dictionary build --config config.json
```

## Accessibility

All color combinations meet WCAG AA contrast requirements (v1.1 values, verified on White and Background #F5F7FA):
- Primary on White: 4.86:1 ✓
- Text on Background: 13.61:1 ✓
- Error (`#CC3333`) on White: 5.14:1 ✓
- Success (`#187F4F`) on White: 5.01:1 ✓
- Warning (`#996200`) on White: 5.12:1 ✓
- Text Muted (`#64707E`) on White: 5.05:1 ✓
- Accent Dark (`#1D9570`) on White: 3.76:1 ✓ (UI graphics, ≥ 3:1)

## Dark Mode

CSS file includes `@media (prefers-color-scheme: dark)` overrides. For other platforms, implement dark mode variants by inverting background/surface and text colors.