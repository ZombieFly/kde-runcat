# RunCat for KDE Plasma

RunCat is a Plasma 6 panel widget. The cat runs faster as total CPU usage
increases and rests when the system is idle. It is designed for KDE Plasma on
Wayland and uses Plasma's existing system-monitor sensor, so no background
daemon is required.

## Requirements

- KDE Plasma 6
- `ksystemstats` and the `org.kde.ksysguard.sensors` QML module
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
caps rendering work at high load.

## License

The implementation is licensed under the Apache License 2.0. The bundled cat
frames come from RunCat Neo and retain their original copyright. See `LICENSE`
and `THIRD_PARTY_NOTICES.md`.
