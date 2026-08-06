# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Changed

#### Multi-component monitoring

RunCat has been reworked into a modular panel widget. Monitoring components can
be added, removed, configured, and reordered independently, so the panel can be
tailored to the information you want to see. New installations start with only
the Runner enabled.

Available components:

- **Runner** — CPU-responsive animation, optional CPU usage, and optional CPU
  temperature.
- **Memory usage** — Physical memory usage ring with used and total values.
- **Disk usage** — Combined disk capacity usage ring with used and total values.
- **Network rate** — Aggregate download and upload rates.
- **GPU usage** — GPU load with optional GPU temperature.
- **Video memory usage** — Used and total video memory.
- **Disk I/O** — Aggregate read and write rates.
- **Codex usage** — Current context and today's local token usage.
- **Claude Code usage** — Current context and today's local token usage.

The former expanded dashboard has been removed; relevant information is now
shown directly in the panel.

#### Other changes

- Moved CPU temperature into the Runner component; it supports Celsius or
  Fahrenheit and color-coded temperature levels.
- Standardized alignment and numeric formatting across percentages, capacities,
  rates, temperatures, and token counts.
- Memory and disk indicators now use compact icon-centered rings with distinct
  colors for each metric.

### Added

- Optional local Codex and Claude Code usage indicators, including separate
  context rings and daily token totals.
- Theme-aware RunCat logo for the KDE widget explorer and panel metadata.

## [0.3.0] - 2026-08-05

### Added

- Optional memory and disk usage pies beside the runner.
- Optional two-line network download and upload rates.
- Optional CPU temperature indicator that turns red above 60°C.
- Configurable spacing between panel indicators.

### Changed

- Increased the size of the memory and disk usage pies.
- Assigned distinct colors to memory, disk, network, and temperature indicators.
- Create GitHub Releases as drafts for manual review before publication.

### Fixed

- Select the actual CPU temperature sensor instead of unrelated hardware sensors.
- Improved spacing in the network section of the expanded dashboard.

## [0.2.0] - 2026-07-28

### Added

- Seven additional runners: Dog, Slime, Drop, Coffee, Newton's Cradle, Engine,
  and Mochi.
- Optional CPU usage percentage beside the runner.
- Option to reverse the animation speed response to CPU usage.

### Changed

- Simplified animation speed configuration to a single running-speed setting.

## [0.1.0] - 2026-07-27

### Added

- Initial Plasma 6 panel widget with CPU-responsive RunCat animation.
- Idle animation, horizontal flipping, speed controls, and theme-aware coloring.
- Expanded dashboard for CPU, GPU, memory, disk, network activity, and local IP.
- Automatic discovery of optional GPU and CPU temperature sensors.
- Packaging, automated release workflow, tests, documentation, and licensing.

[Unreleased]: https://github.com/fioncat/kde-runcat/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/fioncat/kde-runcat/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/fioncat/kde-runcat/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/fioncat/kde-runcat/releases/tag/v0.1.0
