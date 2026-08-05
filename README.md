# RunCat for KDE Plasma

RunCat is a Plasma 6 panel widget. Its animated runner moves faster as total CPU
usage increases and rests when the system is idle. It is designed for KDE
Plasma on Wayland and uses Plasma's existing system-monitor sensor, so no
background daemon is required.

![RunCat responding to CPU usage](assets/runcat-demo.gif)

## Requirements

- KDE Plasma 6
- `ksystemstats` and the `org.kde.ksysguard.sensors` QML module
- KDE's KQuickCharts and KItemModels QML modules
- Python 3 (for optional local Codex and Claude Code token statistics)
- `kpackagetool6`

Arch Linux provides these through the `plasma-workspace`, `ksystemstats`, and
`libksysguard` packages. Other distributions may split them differently.

## Install

```bash
make install
```

Then open **Add Widgets** on a Plasma panel, search for **RunCat**, and drag it
onto the panel. Choose Cat, Dog, Slime, Drop, Coffee, Newton's Cradle, Engine,
or Mochi from its behavior settings. During development, launch it in a
standalone window with:

```bash
make run
```

Run `make uninstall` to remove the locally installed widget.

After changing the widget, install it and restart Plasma Shell in one command:

```bash
make reload
```

## Development

Development checks additionally use `jq`, `xmllint`, Qt's `qmllint` and
`qmltestrunner`, and `zip`.

```bash
make check
make test
make package
```

`make package` creates `build/com.github.runcatkde.runcat.plasmoid` for manual
installation or distribution.

RunCat samples Plasma system-monitor sensors without a background daemon and
smooths CPU data to keep animation stable. Behavior settings control the runner,
speed response, and optional panel indicators for CPU usage and temperature,
memory, disk, and network activity. Clicking the runner opens the full system
dashboard; unavailable hardware sensors are handled automatically.

The optional AI token indicator reads local Codex and Claude Code session logs.
Its two rings show the most recently active session's context usage, while the
adjacent labels show token consumption since local midnight. Cached input is
included. Claude Code does not persist a context-window limit, so its default
200K window can be changed in the widget settings. Codex and Claude Code can
be shown independently, and today's two-line totals are a separate optional
component. No credentials or prompts are sent anywhere by the widget.

### Changelog

Every feature and bug fix must include a short entry under `Unreleased` in
`CHANGELOG.md`.

### Releasing a new version

1. Update the version in `package/metadata.json`.
2. In `CHANGELOG.md`, rename `Unreleased` to the new version and release date,
   then add a new empty `Unreleased` section above it.
3. Commit the release changes with `chore: release x.y.z`.
4. Push the version tag. The release workflow creates a draft GitHub Release;
   verify its notes and artifacts, then publish it manually.

## License

The implementation is licensed under the Apache License 2.0. The bundled runner
frames come from RunCat Neo and retain their original copyright. See `LICENSE`
and `THIRD_PARTY_NOTICES.md`.
