# Motion Decisions

These are design heuristics inspired by Emil Kowalski's work, not accessibility
standards or fixed acceptance thresholds. Tune against the actual interaction.

## Purpose and frequency

Useful motion communicates feedback, state, spatial relationships, or explanation.
Decorative motion can suit an occasional expressive moment; repeating it on a core
workflow can become friction.

| Context | Starting point |
| --- | --- |
| Repeated shortcuts, command palette, rapid navigation | Immediate usability; minimal or no entrance motion |
| Hovering across a toolbar or navigating lists | Short feedback; avoid accumulated delays |
| Occasional popover, modal, drawer, toast | A brief transition that explains the state change |
| Onboarding or explanatory presentation | Longer sequences if they aid understanding and can be skipped |

Keyboard input alone is not a reason to forbid animation. Focus visibility and
readiness for the next action matter more than an estimated uses-per-day count.
Never gate input on decorative animation completion.

## Easing and duration

Start with `ease-out` for prompt entry or feedback, `ease-in-out` for repositioning,
`ease` for subtle color changes, and `linear` for constant motion or elapsed-time
indicators. An accelerating exit can be appropriate when initial feedback is already
clear. Built-in curves are valid; customize only when the result benefits.

Example curves to compare against existing product tokens:

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
```

| Interaction | Initial tuning range |
| --- | --- |
| Press feedback | 100–160 ms, with feedback starting immediately |
| Small tooltip or popover | 125–200 ms |
| Dropdown or select | 150–250 ms |
| Modal or drawer | 200–500 ms, depending on distance and size |
| Explanatory motion | Long enough to understand; avoid delaying a task |

Small UI transitions commonly benefit from finishing within roughly 300 ms. This
is not a hard ceiling for large surfaces, gestures, springs, or accessibility.
Distinguish time to first feedback, readiness for input, and time until all motion
settles. Do not claim perceived speed from duration alone.

## Physicality and interruptibility

- If an anchored overlay scales, align its origin with the trigger. Centered modals
  can scale around their own center. Pure fades need no artificial transform.
- A small scale change, such as `0.95` to `1`, can introduce a surface without
  collapsing its text. Scaling from zero can suit an intentional morph or icon
  effect; judge readability and the intended spatial relationship.
- Retarget from the current visible state when input can reverse. CSS transitions
  often handle simple state changes well. Keyframe or WAAPI implementations can
  also work if they handle cancellation, reversal, and current progress.
- Springs suit momentum and interactive reversal. Verify the chosen API preserves
  velocity when retargeting; the word "spring" alone does not guarantee it.

Some libraries offer duration/bounce springs and others use mass, stiffness, and
damping. Their values are not interchangeable. Example starting configurations,
only where the installed library supports these forms:

```js
{ type: "spring", duration: 0.4, bounce: 0.2 }
{ type: "spring", mass: 1, stiffness: 100, damping: 10 }
```

Start with little or no overshoot for functional UI. More bounce may suit an
expressive component or momentum-driven release. Decorative pointer tracking can
use a spring; a functional slider or drag should normally track input directly.

## Sequence and cohesion

A deliberate hold action may take longer to commit than to cancel. That asymmetry
is useful for hold-to-confirm; it is not mandatory for every press or enter/exit
transition. Provide immediate press feedback even during the hold.

Stagger can explain a small group or hierarchy. Try 30–80 ms between items when
appropriate, but cap total delay and keep controls operable. Long lists and repeated
navigation often work better with simultaneous updates or no entrance animation.

Match motion to neighboring components and the product's personality. A calmer
toast can use a softer curve than a command palette. Do not add blur, bounce, or
stagger where an ordinary fade or static update is already clear.
