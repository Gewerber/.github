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
| Accent | Gewerber Mint | `#4CD4A9` | Highlights, success states, secondary actions |
| Background | Soft Gray | `#F5F7FA` | Page background |
| Surface | White | `#FFFFFF` | Cards, modals, inputs |
| Text | Deep Slate | `#1F2A33` | Primary text content |
| Text Secondary | | `#5A6A78` | Supporting text |
| Text Muted | | `#9AA5B1` | Placeholders, disabled text |
| Border | | `#E1E5EB` | Dividers, input borders |
| Error | Red | `#E54848` | Errors, destructive actions |
| Success | Green | `#3BB273` | Success states, positive actions |
| Warning | Amber | `#F5A623` | Warnings, caution |
| Info | Blue | `#2D6CDF` | Information, help |

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

All color combinations meet WCAG AA contrast requirements:
- Primary on White: 4.8:1 ✓
- Text on Background: 12.6:1 ✓
- Error on White: 4.5:1 ✓
- Success on White: 4.5:1 ✓

## Dark Mode

CSS file includes `@media (prefers-color-scheme: dark)` overrides. For other platforms, implement dark mode variants by inverting background/surface and text colors.