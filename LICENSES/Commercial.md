# QML MD3 Commercial License

**Status:** Terms template for commercial licensing and vendor certification.
Contact the copyright holders to obtain a signed agreement (this file alone is
not a grant of commercial rights).

## Purpose

Similar to Qt’s commercial option, the Commercial License is for teams that:

- Cannot or prefer not to meet **LGPL-3.0** obligations (dynamic linking /
  relinking, notices, source offer for the library, etc.)
- Need **vendor certification** (“QML MD3 Certified” application / integrator)
- Want commercial support, indemnification options, or longer maintenance

## What a commercial grant typically covers

- Right to use, modify, and distribute QML MD3 in proprietary products without
  LGPL copyleft obligations on your application code
- Optional **certification**: review of integration against published checklists
  (a11y spot-check, packaging, API stability), issuance of a certificate ID
- Support channel and agreed response targets (as specified in the order form)

## What it does not replace

- Your obligations for **third-party** components (Qt, fonts, icons) — see
  `NOTICE` and Qt’s own licensing
- Trademark use of “QML MD3” / certification marks without a trademark schedule

## How to buy / inquire

1. Email or open a private channel with the project maintainers (repository
   owner: `wuyijing-dev` on GitHub).
2. Describe product, distribution model (app / embedded / OEM), and whether you
   need certification.
3. Receive quote + Commercial License Agreement (CLA) + optional Certification
   Statement of Work.

## Open-source alternative

If you can comply with LGPL-3.0, use the library under
`LICENSES/LGPL-3.0-only.txt` at no charge — no commercial agreement required.

## Certification program (roadmap)

| Level | Intent |
|-------|--------|
| **Integrator** | App correctly packages shared/static Md3, follows Public API |
| **Desktop Shell** | Passes a11y spot-check + window/chrome checklist |
| **OEM** | Custom support window + named release train |

Exact fees and audit steps are defined in the commercial order form, not in
this repository.
