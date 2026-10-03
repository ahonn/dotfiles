# Web Component Patterns

Use existing component primitives first. Check target browser support and the
installed library's APIs before copying a pattern.

## Press feedback and anchored overlays

Press feedback starts on pointer-down; committing normally waits for activation
so the user can cancel. Small scale, color, highlight, and elevation are alternative
feedback choices. Preserve a visible keyboard focus state.

```css
.button {
  transition: transform 160ms ease-out;
}

.button:active {
  transform: scale(0.97);
}

.popover {
  transform-origin: var(--radix-popover-content-transform-origin);
}
```

The origin variable above is specific to Radix; use the equivalent from the actual
library or compute an anchor. It is unnecessary for centered modals or pure fades.

Tooltips benefit from an initial delay to avoid accidental activation. If the
library supports a group grace period, show adjacent tooltips promptly after one
is open. Support keyboard focus and do not hide essential information behind hover.

## Entry, exit, and toast lifecycle

Where supported, `@starting-style` can provide entry values without a React effect
solely to toggle a mounted flag:

```css
.toast {
  opacity: 1;
  transform: translateY(0);
  transition: opacity 200ms ease-out, transform 200ms ease-out;

  @starting-style {
    opacity: 0;
    transform: translateY(8px);
  }
}
```

Exit still needs an appropriate presence/removal lifecycle. Reuse the component
library's mechanism where possible. For older browsers, use the project's approved
entry mechanism rather than introducing an effect without checking policy.

Toast and stacked-list details:

- Retarget positions when items arrive, leave, or change height.
- Define timer behavior while focused, hovered, or backgrounded.
- Avoid hover gaps between related surfaces and preserve tracking during drag.
- Keep announcements, dismissal, focus, and updates working with motion disabled.
- Animate height when moving surrounding content is intentional; check cost with
  realistic content rather than distorting text through scale.

Good defaults and a small public interface reduce adoption work. Hide lifecycle
edge cases inside the component. Interactive documentation is useful for reusable
components, not a required deliverable for every UI fix.

## Transforms, clipping, and reveals

For ordinary CSS boxes, translate percentages use the element's transform reference
box. `translateY(100%)` can move a drawer by its own height; use explicit distances
when movement is tied to its container or another object. `scale()` also scales
text and children, so evaluate legibility during large changes.

3D effects use `rotateX()`, `rotateY()`, perspective, and `transform-style:
preserve-3d` when depth communicates something. They are optional expressive tools.

`clip-path: inset(top right bottom left)` trims a rectangular region:
`inset(0 100% 0 0)` hides it from the right; `inset(0 0 0 0)` reveals it.
Potential uses:

- A comparison slider: overlay images and vary the top image's inset.
- A tab highlight: clip a visual duplicate of the active styling; make the duplicate
  non-interactive and hidden from assistive technology.
- A scroll reveal: reveal once on entry; keep content available if scripting fails
  or reduced motion is enabled.
- A hold-progress overlay: fill linearly while held and clear promptly on cancel.
  The fill alone must not implement the action or its cancellation logic.

Example visual timing for a deliberate hold:

```css
.hold-overlay {
  clip-path: inset(0 100% 0 0);
  transition: clip-path 200ms ease-out;
}

.hold-button:active .hold-overlay {
  clip-path: inset(0 0 0 0);
  transition: clip-path 2s linear;
}
```

Clipping, blur, and masking are not automatically compositor accelerated. Measure
cost before using them on large or continuously moving surfaces. A subtle temporary
blur can soften an awkward crossfade, but first check alignment and lifecycle.
Do not blur text merely to conceal a bug.
