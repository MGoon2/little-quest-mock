# Little Quest Design System

## 1. Atmosphere & Identity

Little Quest feels like a warm field guide for children and parents: safe, gentle, curious, and nature-first. The signature is watercolor exploration: cream paper surfaces, rounded green controls, soft botanical illustration, and small nature cues that make product flows feel like part of an outdoor quest rather than a generic form.

## 2. Color

### Palette

| Role | Token | Light | Dark | Usage |
| --- | --- | --- | --- | --- |
| Surface/primary | `LqColors.cream` | `#FFFBF1` | n/a | Page backgrounds for nature-themed feature screens |
| Surface/card | `LqColors.cardCream` | `#FFFCF4` | n/a | Cards, input fills, social buttons |
| Surface/soft | `LqColors.softGreen` | `#EAF4DC` | n/a | Soft notice cards, quiet success surfaces |
| Surface/tint | `LqColors.lightGreen` | `#DDECCB` | n/a | Step indicators, botanical panels |
| Accent/primary | `LqColors.primaryGreen` | `#3F7334` | n/a | Primary buttons, active steps, check states |
| Accent/deep | `LqColors.deepGreen` | `#245A2E` | n/a | Titles, important links, emphasis |
| Accent/muted | `LqColors.mutedGreen` | `#7C9A68` | n/a | Secondary decorative details |
| Accent/yellow | `LqColors.yellow` | `#F4B83A` | n/a | Nature highlights and small warm accents |
| Accent/kakao | `LqColors.kakaoYellow` | `#FEE500` | n/a | Kakao provider mark only |
| Text/primary | `LqColors.textDark` | `#1F2A1F` | n/a | Labels, body copy, form text |
| Text/secondary | `LqColors.textSubtle` | `#7A7D73` | n/a | Helper text, dividers, inactive labels |
| Border/default | `LqColors.border` | `#E7DEC8` | n/a | Cards and soft dividers |
| Border/input | `LqColors.inputBorder` | `#E2DED3` | n/a | Input and selector outlines |
| State/disabled | `LqColors.disabled` | `#D8D8D0` | n/a | Inactive steps and disabled controls |

### Rules

- Use `LqColors` for immersive feature screens that match the illustrated Little Quest style.
- Use one primary green CTA per screen group; secondary actions stay card-colored with borders.
- Provider brand colors may appear only inside the provider mark, not as page accents.
- Add new colors to this table before using them in new UI.

## 3. Typography

### Scale

| Level | Size | Weight | Line Height | Tracking | Usage |
| --- | ---: | ---: | ---: | ---: | --- |
| Display | 34px | 800 | 1.2 | 0 | Signup/welcome hero titles |
| H1 | 24px | 700 | 1.3 | 0 | Page app bar titles, major form titles |
| H2 | 20px | 700 | 1.35 | 0 | Card titles, section titles |
| H3 | 18px | 700 | 1.4 | 0 | Compact headings |
| Body/lg | 16px | 600 | 1.5 | 0 | Buttons, important body text |
| Body | 15px | 500 | 1.5 | 0 | Inputs, social button labels |
| Body/sm | 14px | 400 | 1.5 | 0 | Helper text, secondary copy |
| Caption | 12px | 500 | 1.4 | 0 | Step numbers, short metadata |

### Font Stack

- Primary: Pretendard, system UI, sans-serif
- Display: Jua for Korean display headings
- Brand accent: Fredoka for logo-like English text when needed

### Rules

- Body text should not be below 12px in compact metadata and should stay 14px or larger for reading copy.
- Labels sit above inputs; placeholders never replace labels.
- Keep letter spacing at 0 for new Flutter UI unless using an existing token that already defines it.

## 4. Spacing & Layout

### Base Unit

All spacing derives from a 4px base.

| Token | Value | Usage |
| --- | ---: | --- |
| `AppSpacing.xs` | 4px | Tight icon or helper gaps |
| `AppSpacing.sm` | 8px | Label-to-field gaps |
| `AppSpacing.md` | 12px | Button lists, compact vertical rhythm |
| `AppSpacing.lg` | 16px | Form group spacing, default section gaps |
| `AppSpacing.xl` | 20px | Screen padding and card padding |
| `AppSpacing.xxl` | 24px | Major vertical grouping |
| `AppSpacing.xxxl` | 32px | Page section breaks |

### Grid

- Mobile-first content width.
- Primary phone layout uses 24px horizontal padding on immersive signup/account screens.
- Fixed-format controls define stable heights: 56px for buttons and inputs, at least 48px touch targets.

### Rules

- New spacing values should be multiples of 4.
- Feature screens can use asymmetric vertical spacing only to match an illustration or keyboard-safe form layout.

## 5. Components

### Signup Method Button

- **Structure**: full-width button, fixed 58px height, leading provider mark, centered label.
- **Variants**: primary email, bordered social.
- **Spacing**: 20px horizontal padding, 12px between stacked buttons.
- **States**: default, pressed, disabled where applicable.
- **Accessibility**: semantic label includes provider and action.

### Signup Text Field

- **Structure**: label above `TextField`, optional helper below, optional trailing password toggle.
- **Variants**: normal, password, disabled selector-like field.
- **Spacing**: 8px label gap, 10px helper gap.
- **States**: default, focus, error-ready via validation hook, disabled.
- **Accessibility**: label and hint are explicit.

### Security Notice Card

- **Structure**: soft green rounded card with shield icon, safety copy, botanical accent.
- **Spacing**: 18-20px padding.
- **States**: static informational surface.
- **Accessibility**: copy is readable as text, decoration excluded from interaction.

## 6. Motion & Interaction

### Timing

| Type | Duration | Easing | Usage |
| --- | ---: | --- | --- |
| Micro | 100-150ms | ease-out | Button press, toggle feedback |
| Standard | 200-300ms | ease-in-out | Form state changes and route transitions |

### Rules

- Prefer Material route transitions already provided by Flutter.
- Button feedback should use Material ink or a small opacity/scale change, not layout movement.
- Respect platform accessibility settings by avoiding non-essential continuous animation.

## 7. Depth & Surface

### Strategy

Mixed: thin beige borders plus very soft tinted shadows.

| Level | Value | Usage |
| --- | --- | --- |
| Subtle | `0 4px 12px rgba(31, 42, 31, 0.05)` | Signup buttons and cards |
| Soft | `0 8px 20px rgba(31, 42, 31, 0.06)` | Elevated notice or illustration panels |
| Border/default | `1px solid LqColors.border` | Cards and social buttons |
| Border/input | `1px solid LqColors.inputBorder` | Text inputs and dropdown selectors |

### Rules

- Shadows must stay green/brown tinted and low opacity.
- Inputs and social buttons use borders for clarity; large surfaces may use tonal shift.
