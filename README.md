# Star Dodger

Small single-file browser arcade game (HTML/CSS/JS).

## Files

- `index.html` — self-contained game (HTML, embedded CSS and JS).

## How to run

- Open `index.html` in your browser (double-click or use PowerShell):

```powershell
Start-Process index.html
```

## Controls

- Move: Left / Right arrow or A / D
- Pause / Restart: Space / R / Enter
- M: mute/unmute audio

## Features

- Start screen, in-game HUD (score / high score)
- Falling asteroids, collectible stars
- Smooth gameplay loop, difficulty ramp
- Particle and floating text feedback
- Inline WebAudio sound effects with persisted mute

## Package (create zip)

You can create a zip with PowerShell in the folder containing `index.html` and `README.md`:

```powershell
Compress-Archive -Path index.html,README.md -DestinationPath StarDodger.zip -Force
```

Or include any additional files/folders by listing them in `-Path`.

## Notes

- High score and mute preference are saved in `localStorage` per browser profile.
- The game is intentionally dependency-free so it runs locally without a server.
