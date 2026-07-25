# Visual regression workflow

Goal: catch fidelity drift vs Flutter Material 3 / m3.material.io.

## Baseline sources
1. Flutter Gallery / Material 3 demo (same seed `#6750A4` when possible)
2. Component specs screenshots from m3.material.io
3. Local Gallery pages under matching light/dark

## Capture
1. Run Gallery Debug build
2. Navigate to the component page
3. Capture window or control region (same DPR each time)
4. Store under `tests/baselines/<component>/<variant>_<theme>.png` (create as needed)

## Compare
- Side-by-side diff in any image tool
- Check: size, corner, color role, state layer, motion timing (screen recording optional)

## Automation (optional later)
- Qt Quick Test + screenshot grab
- CI threshold on pixel diff percentage

## Acceptance
A control is **stable** only after:
- [ ] Spec doc complete in `docs/md3`
- [ ] Gallery state matrix (enabled/disabled/hover/focus/press/error as relevant)
- [ ] Light + dark baselines reviewed
- [ ] Motion durations match `Md3Motion` tokens
