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

## Components

New installations start with only the Runner. The widget settings can add,
remove, configure, and reorder memory, disk, network, and AI indicators. AI
usage is read locally from Codex and Claude Code session logs;
no credentials or prompts are sent anywhere.

## Development

Development requires `jq`, `xmllint`, Qt's QML tools, and `zip`.

```bash
make check    # Static checks
make test     # Automated tests
make reload   # Install and restart Plasma Shell
make package  # Build the .plasmoid package
```

Release changes should update `package/metadata.json` and `CHANGELOG.md` before
the version tag is pushed. CI creates the GitHub Release as a draft.

## License

The implementation is licensed under the Apache License 2.0. The bundled runner
frames come from RunCat Neo and retain their original copyright. See `LICENSE`
and `THIRD_PARTY_NOTICES.md`.
