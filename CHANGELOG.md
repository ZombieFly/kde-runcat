# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Changed

- Reworked RunCat into a modular panel widget whose Runner, memory, disk,
  network, and AI indicators can be added, removed, configured,
  and reordered independently. New installations start with only the Runner;
  memory and disk use compact icon-centered rings, and optional Codex and
  Claude Code usage is read from local session data. The CPU temperature
  indicator and separate dashboard were removed now that the relevant
  information can be shown in the panel.

### Fixed

- Stabilized dynamic component loading, configuration-page layout, and panel
  sizing while preserving existing settings during migration.

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
