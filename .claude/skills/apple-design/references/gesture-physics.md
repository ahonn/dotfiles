# Gesture Physics

Adapted from ideas in Apple's *Designing Fluid Interfaces* (WWDC 2018). Equations
below are implementation examples with explicit units, not universal gesture
thresholds or guaranteed mappings between animation libraries.

## Response and direct manipulation

Give visual feedback on pointer-down; commit a tap through the platform's activation
semantics so cancellation and keyboard activation remain available. During a drag,
track the pointer directly and retain the initial grab offset. Smoothing that makes
functional content trail the finger weakens direct manipulation.

Use Pointer Events and capture when appropriate. Track the active pointer ID and
handle `pointercancel`, lost capture, release, and unmount. Extra touches should not
unexpectedly replace the active pointer. Coordinate `touch-action` and direction
recognition with page scrolling rather than disabling all scrolling by default.

Maintain recent position/timestamp samples for release velocity. The entire drag's
average speed can misclassify a flick after a pause or reversal. Choose a short
window that is stable enough for the input hardware.

## Interruptibility and springs

When input reverses, retarget from the visible position rather than the old logical
target. Preserve velocity when the interaction calls for momentum. A spring engine
with explicit retargeting and velocity handoff is useful for gesture settling.

CSS transitions are sufficient for many reversible state changes. They can be
retargeted, but grabbing a surface during a transition requires coordinating the
current presentation state with the drag. Neither springs nor keyframes solve
lifecycle or cancellation automatically. Verify the actual implementation.

For independent two-axis motion, track each axis's position and velocity. This
avoids assuming identical velocities along a single interpolated path.

Spring vocabulary:

- Damping ratio `1`: critically damped; no overshoot.
- Damping ratio below `1`: underdamped; permits overshoot.
- Response: a speed parameter in APIs that expose it, not necessarily total
  settling duration.
- Mass, stiffness, and damping coefficients: physical parameters; damping
  coefficient is not the same value as damping ratio.

Begin with little or no overshoot for functional controls. Small bounce can suit
momentum-driven release. Example response ranges of 0.3–0.4 seconds and damping
ratios near 0.8–1 are tuning starting points only for APIs using those definitions.
A web library's `bounce`/`duration` options are not interchangeable with Apple's
response/damping or another library's stiffness settings.

## Velocity handoff and projection

Check units: browser positions are commonly CSS pixels, timestamps milliseconds,
and spring velocity may be pixels per second. Convert before handing off velocity.

Some APIs take normalized velocity:

```text
relativeVelocity = releaseVelocity / (targetPosition - currentPosition)
```

Only normalize for an API that requires it. Handle zero or tiny remaining distances
with that API's documented behavior rather than dividing by zero or generating an
extreme velocity. Other APIs accept absolute velocity directly.

Projecting the release position can help a flick reach the expected snap point.
One exponential-decay model, with velocity in px/s and decay per millisecond:

```js
function projectedDistance(velocity, decay = 0.998) {
  if (!(decay > 0 && decay < 1)) {
    throw new RangeError("Decay must be between zero and one");
  }
  return (velocity / 1000) * decay / (1 - decay);
}
```

Then choose among permitted snap targets near `position + projectedDistance(v)`
and settle with the release velocity. Tune the decay and target-selection policy
to the component. Use direction, position, and allowed outcomes together; velocity
alone must not turn an accidental movement into a destructive commitment.

A dismissal threshold needs explicit units and actual device evaluation. Avoid a
universal number copied from a toast or drawer with a different travel distance.

## Boundaries and gesture recognition

Rubber-banding can show that a boundary has been reached without freezing feedback.
For a signed overshoot and positive dimension, one possible curve is:

```js
function rubberband(overshoot, dimension, constant = 0.55) {
  return (
    (overshoot * dimension * constant) /
    (dimension + constant * Math.abs(overshoot))
  );
}
```

Require a positive dimension and constant when integrating this model. Apply it
only outside the valid range; direct manipulation should remain linear inside.
The constant is an example, not a platform requirement.

Use a small movement threshold before committing to a drag direction, sized for
the input device and surrounding scroll behavior. A threshold around 10 CSS pixels
can be a prototype starting point, not a universal hit target or native point value.

Detect plausible gestures early and resolve conflicts once intent is clear. Avoid
delaying single taps for double-tap recognition unless double-tap exists. During
cancel or release, restore coherent visual and logical state.

## Verification

Try rapid grab/release, reversal during settle, release near a snap point, a slow
drag followed by a flick, boundary overshoot, multi-touch, scroll conflicts, and
cancellation where relevant. Check normal speed first; use slow playback to locate
discontinuities. Tune on real input hardware when available.

For reduced motion, preserve the gesture's functional feedback while reducing
nonessential travel, oscillation, and settling effects. Do not make motion completion
a prerequisite for state changes or cleanup.
