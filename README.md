# OpenBox

A very simple, open-source PC physics sandbox. Starts extremely small on purpose.

Inspired by the general concepts of Garry's Mod, BONELAB, BONEWORKS, and s&box — but kept tiny and easy to mod.

Base game: engine + 1 Sandbox map + 1 Glock 17 + 1 stickman + physics + menus + settings + mod system. Everything else is a mod.

## Play it

Play in the browser: https://elipoop94.github.io/openbox-opensource-sandbox-game-/

Or open `index.html` locally — it's a self-contained build of the game.

Desktop, first-person. Click to play, WASD to move, Shift to sprint, Space to jump.

- Mouse — look around, full 360°. Where pointer lock works, click captures the mouse. Where it's blocked, just move the mouse, or hold it against a screen edge to keep spinning.
- `Q` or `Tab` — spawn menu (Cube / Barrel / Stickman / Glock 17)
- `Left click` — fire / grab
- `R` — reload Glock (17-round mag)
- `E` — grab / push the object you're looking at
- `Esc` — pause / back to menu

## Folder layout

```
OpenBox/
├── index.html             # playable game (GitHub Pages entry point)
├── Maps/
│   └── sandbox/           # the only built-in map
│       └── map.json
├── Mods/
│   ├── MyMap/             # example map mod (enabled)
│   ├── MyWeapon/          # example weapon mod (enabled)
│   └── TestMod/           # example disabled mod
├── skills/
│   └── openbox-modding/   # the modding skill — how to make mods
│       └── SKILL.md
└── docs/
    └── MODDING.md         # how to make a mod
```

## Modding

Mods are just folders in `Mods/` with a `mod.json`. No installer, no registry.

See `docs/MODDING.md` for the full guide: `mod.json`, `map.json`, and the Lua API:

```lua
OpenBox.RegisterWeapon("my_weapon")
OpenBox.RegisterEntity("my_entity")
OpenBox.RegisterMap("my_map")
```

Mods can add maps, props, weapons, NPCs, tools, models, sounds, and scripts.

## The modding skill

This repo implements the `openbox-modding` skill, in `skills/openbox-modding/SKILL.md`.

It is the playbook for making OpenBox mods — mod folder layout, `mod.json` and `map.json` schemas with the real MyMap / MyWeapon examples, the `OpenBox.RegisterWeapon / RegisterEntity / RegisterMap / RegisterProp / RegisterTool` Lua API, how to add each type (maps, props, weapons, NPCs, tools, models, sounds, scripts), enable/disable, how to test in the game, rules, and troubleshooting.

If you use an AI agent to make a mod, give it that skill file first.

## Rules

- Do NOT hard-code custom maps into the base game. Only `Sandbox` ships built-in.
- No multiplayer, vehicles, advanced AI, campaigns, quests, or crafting yet.
- Desktop first. VR is architecture-only for now — see `docs/MODDING.md`.

## Known limits

- Settings apply instantly but do not persist across reload in this static web build.
- VR is architecture-ready only (XR renderer + WebXR support check), not a playable VR mode yet.

## License

MIT — see `LICENSE`.
