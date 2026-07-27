# RunCat for KDE Plasma

RunCat is a Plasma 6 panel widget. The cat runs faster as total CPU usage
increases and rests when the system is idle. It is designed for KDE Plasma on
Wayland and uses Plasma's existing system-monitor sensor, so no background
daemon is required.

![RunCat responding to CPU usage](assets/runcat-demo.gif)

## Requirements

- KDE Plasma 6
- `ksystemstats` and the `org.kde.ksysguard.sensors` QML module
- KDE's KQuickCharts and KItemModels QML modules
- `kpackagetool6`

Arch Linux provides these through the `plasma-workspace`, `ksystemstats`, and
`libksysguard` packages. Other distributions may split them differently.

## Install

```bash
make install
```

Then open **Add Widgets** on a Plasma panel, search for **RunCat**, and drag it
onto the panel. During development, launch it in a standalone window with:

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

The CPU sensor is sampled at most once per second. An exponentially weighted
moving average prevents brief spikes from making the animation jitter. CPU
sampling and frame animation use separate clocks, and the configured FPS limit
caps rendering work at high load. A single running-speed percentage scales the
full animation speed range while the timing and smoothing details use sensible
defaults. The behavior settings can optionally show the current CPU percentage
to the right of the cat; this display is disabled by default. They can also
reverse the speed response so the cat runs faster at low CPU usage and slower at
high CPU usage.

Clicking the cat opens a Plasma dashboard with CPU, GPU, memory, disk, and
network activity. The dashboard uses Kirigami and KQuickCharts so its colors,
fonts, and spacing follow the active Plasma theme. GPU and temperature sensors
are discovered at runtime and are shown as unavailable when the hardware or
driver does not expose them through `ksystemstats`.

## License

The implementation is licensed under the Apache License 2.0. The bundled cat
frames come from RunCat Neo and retain their original copyright. See `LICENSE`
and `THIRD_PARTY_NOTICES.md`.
