# Progress indicators

## Sources
- M3: https://m3.material.io/components/progress-indicators/specs
- Expressive wavy: Android `LinearWavyProgressIndicator` / `CircularWavyProgressIndicator`

## Linear styles (`Md3LinearProgressIndicator.Style`)
| Style | Look |
|-------|------|
| **Standard** | Flat track 4dp, pill ends, determinate stop dot |
| **Wavy** | Expressive sine wave, thickness 8, amp 3 |
| **Soft** | Gentle wave, thickness 6, amp 2, longer wavelength |
| **Lively** | Bold expressive, thickness 10, amp 5, shorter wavelength |

## Circular styles (`Md3CircularProgressIndicator.Style`)
| Style | Look |
|-------|------|
| **Standard** | Flat stroke 4 |
| **Wavy** | Wave count 5, amp 2.5 |
| **Soft** | Wave count 4, amp 1.5 |
| **Lively** | Wave count 8, amp 3.5 |

## Motion / perf
- Indeterminate travel/spin gated until one frame after visible (`motionReady`) to avoid first-open hitch
- Canvas paints coalesced ~30fps
- Tokens: `progressTravel` 1800, `progressSpin` 1600, `progressSweep` 1100, `progressWave` 2400
