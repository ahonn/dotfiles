# Materials and Typography

Web adaptations of Apple's material hierarchy and typography practices. Preserve
the product's visual identity and platform conventions; translucency is an option,
not a requirement for every toolbar or sheet.

## Materials and depth

A translucent functional layer can keep underlying context visible while separating
navigation or controls. On the web, a semitransparent background and
`backdrop-filter` can approximate that effect:

```css
.toolbar {
  background: rgba(255, 255, 255, 0.8);
}

@supports (backdrop-filter: blur(20px)) {
  .toolbar {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(20px) saturate(180%);
  }
}
```

These values illustrate a light surface, not a contrast guarantee. Evaluate dark
mode, busy content, scrolling, and unsupported-filter fallbacks.

- Use material weight, shadow, and background opacity to express hierarchy.
  Stacking several translucent surfaces can reduce legibility; inspect real content.
- Larger surfaces may need stronger separation, but stronger blur is not always
  the best solution. Solid fills and clear borders can be simpler and faster.
- Use a scrim for a modal task when it communicates blocked background interaction.
  A parallel nonmodal panel may keep the background available. Keep focus and
  interaction semantics consistent with the visual treatment.
- Text and icons must remain legible over changing backgrounds. Increase background
  opacity or use a solid local backing where needed; weight or tracking adjustments
  alone do not guarantee sufficient contrast.
- A scroll-edge gradient or blur can soften the boundary where content passes under
  floating chrome. Use a divider instead when it better communicates structure.
- Animating blur with scale can suggest a material arriving, but is optional and
  potentially expensive. Static material plus a fade is valid. Profile large
  filtered surfaces and avoid unnecessary permanent layer promotion.

## Transparency, contrast, and motion settings

Treat reduced motion, reduced transparency, and increased contrast independently.
Use supported media queries as progressive enhancement and keep a legible default:

```css
@media (prefers-reduced-transparency: reduce) {
  .toolbar {
    background: white;
    backdrop-filter: none;
  }
}

@media (prefers-contrast: more) {
  .toolbar {
    background: white;
    border-bottom: 1px solid black;
  }
}
```

Adapt colors to the theme. Reduced motion can use a static state or short fade.
Avoid unnecessary large travel, parallax, repeated oscillation, and abrupt visual
flashes. Do not add a global transition that creates new delays or brightness
effects while trying to address sensitivity.

## Typography

Build hierarchy with size, weight, leading, and spacing together. Use the actual
font's metrics and script rather than universal tracking rules.

- Large Latin display text may benefit from tighter tracking; small text may need
  more breathing room. Do not apply those heuristics blindly across languages.
- Body text normally needs more generous line height than a large heading. Check
  diacritics, tall scripts, wrapping, and dense controls.
- Support browser zoom and user font scaling. Relative units and flexible layout
  help; test the rendered result rather than assuming `rem` alone is sufficient.
- System fonts are a useful default for platform familiarity. Preserve an existing
  brand typeface when it serves the product.
- Enable optical sizing when the chosen font supports it.

```css
:root {
  font: 100%/1.5 system-ui, sans-serif;
}

.display {
  font-size: clamp(2rem, 5vw, 4rem);
  line-height: 1.05;
  letter-spacing: -0.02em;
  font-optical-sizing: auto;
}
```

The display values are an example for an appropriate Latin font, not a multilingual
typography specification. Inspect long labels, localization, increased text size,
and contrast in the affected surfaces.
