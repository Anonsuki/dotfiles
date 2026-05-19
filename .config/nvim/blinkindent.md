# Architectural Debt & Future Optimizations

## [UI/Physics] The Indent Engine (Last Checked: March 2026)

- **Current Engine:** `snacks.indent` (1.5ms render, flawless Z-index layering).
- **Target Engine:** `blink.indent` (0.15ms render, currently buggy).
- **The Blocker:** `blink.indent` currently fails to properly render a thick active scope character (`┃`) over a thin background character (`▏`). It causes severe terminal grid artifacting.
- **Action Item:** Monitor the `blink.indent` repository. Once Saghen implements proper Z-index extmark priority or fixes the visual overlap bugs, strip out `snacks.indent` and deploy Blink for maximum zero-latency execution.
