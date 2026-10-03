# Performance and Accessibility

This reference targets browsers. React Native drivers, native views, and platform
accessibility settings require their own implementation and measurements.

## Rendering cost

Prefer `transform` and `opacity` for movement or fades when they preserve intended
layout and content. They are often eligible for compositing, but neither property
names nor animation libraries guarantee GPU execution or smoothness.

Width, height, padding, or position animation can require layout or paint. That can
be appropriate when an expanding region must move its siblings. Bound the work,
use realistic content, and measure before substituting a transform that stretches
text or breaks hit testing. FLIP and layout primitives are options when justified.

Investigation leads:

- `transition: all` can animate unintended changes. Enumerate intended properties,
  especially when unrelated styles change during a transition.
- Updating an inherited custom property high in a large subtree can cause broad
  style invalidation. Scope it near its consumer or update a local transform if a
  trace shows costly recalculation. Registered non-inherited properties are another
  option where supported.
- Motion/Framer Motion shorthands and full transform strings may follow different
  rendering paths depending on version, feature, and browser. Inspect and profile
  the installed implementation; do not mechanically replace every `x` or `y`.
- CSS, WAAPI, and library animations can all involve main-thread work. Properties,
  compositing eligibility, and surrounding rendering load matter.
- `requestAnimationFrame` follows the browser's rendering schedule but still runs
  JavaScript on the main thread. Keep per-frame work small and avoid layout
  read/write thrashing.
- Blur, `backdrop-filter`, clipping, large layers, and permanent `will-change` can
  consume rendering or memory resources. Use promotion hints only where needed.

## Reduced motion and input modes

Honor `prefers-reduced-motion` through the complete entry and exit lifecycle,
including library-driven motion. Replace large translation, parallax, or repeated
oscillation with a static state or brief fade when suitable. Zero animation is
valid. Preserve state feedback, focus, announcements, and completion behavior.

```css
@media (prefers-reduced-motion: reduce) {
  .toast {
    transition: none;
    transform: none;
  }
}

@media (hover: hover) and (pointer: fine) {
  .button:hover {
    transform: translateY(-1px);
  }
}
```

Optional hover motion should not leave sticky states on touch. Media queries are
one approach; verify hybrid devices and the component library's behavior. Never
require hover for essential functionality. Equivalent functionality across inputs
does not require identical motion.

## Verification

Choose checks for the actual risk:

- At normal speed, check first feedback and readiness for the next action.
- Rapidly toggle, dismiss, reopen, reverse, or cancel where supported. Look for
  jumps, stuck values, stale completion callbacks, and input lockout.
- Use slow playback or frame-by-frame inspection to diagnose origin, alignment,
  crossfades, and synchronization; restore normal timing to judge responsiveness.
- Profile suspected frame drops under representative content and load on a relevant
  device. A source-level risk is not an observed performance defect.
- Exercise reduced motion, keyboard, and touch where affected. Real hardware is
  useful for gesture feel; disclose if it was unavailable.

In reviews, distinguish reproducible behavior, measured problems, reasoned risks,
and stylistic suggestions. Report evidence and the smallest useful fix. Do not
invent a defect because a value differs from a tuning table.
