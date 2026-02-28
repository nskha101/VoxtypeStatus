# VoxtypeStatus

DMS Shell bar widget that shows [Voxtype](https://github.com/nskha101/voxtype) voice-to-text status in real time.

## Features

- Live status indicator: idle, recording, transcribing, stopped
- Click to open popout with quick actions:
  - **Restart Service** — restarts the voxtype systemd user service
  - **Open Config** — opens `~/.config/voxtype/config.toml` in your editor (`$EDITOR`, falls back to `code`)
- Color-coded states (recording = red, transcribing = accent, idle = default)
- Multiple icon themes: emoji, nerd font, minimal, dots, text
- Option to hide when idle
- Auto-reconnects if the voxtype process dies

## Install

Clone into your DMS plugins directory:

```bash
git clone https://github.com/nskha101/VoxtypeStatus.git ~/.config/DankMaterialShell/plugins/VoxtypeStatus
```

Then reload the plugin:

```bash
dms ipc plugins reload voxtypeStatus
```

## Requirements

- [DMS Shell](https://github.com/nicedayzhu/dms-shell)
- [Voxtype](https://github.com/nskha101/voxtype) installed and running as a systemd user service

## Settings

Configure via DMS Shell settings panel:

| Setting | Default | Description |
|---------|---------|-------------|
| Icon Theme | emoji | Icon style — emoji, nerd font, minimal, dots, or text |
| Hide When Idle | false | Only show the widget when recording or transcribing |

## License

MIT
