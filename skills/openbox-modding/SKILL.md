---
name: openbox-modding
description: Make mods for OpenBox, the small PC physics sandbox. Covers new maps, props, weapons, NPCs, tools, models, sounds and scripts via the Mods folder, mod.json, map.json and the OpenBox Lua API. Also covers the in-game Map Builder and Community Maps publishing (v0.1.5): build a map inside the game and publish it for other players to download, 3 maps per week per device. Use when the user wants a new map, prop, weapon, NPC, tool, model, sound or script for OpenBox ("add a map to OpenBox", "make a weapon for OpenBox", "add a stickman / NPC to OpenBox").
---

# OpenBox modding

OpenBox starts extremely small on purpose. The base game is the engine + one Sandbox map + one Glock 17 + one stickman + physics + menus + settings + the mod system. Everything else is a mod.

Source of truth in this workspace: `~/workspace/openbox/` — `README.md`, `docs/MODDING.md`, `Maps/sandbox/map.json`, and the example mods under `Mods/`. The playable game is the `openbox` web artifact; do not edit the artifact to add content — add a mod instead.

## When to use this skill

Use it when the user wants any of these for OpenBox: a map, prop, weapon, NPC, tool, model, sound, or script. Do not use it for changes to the base game itself (menus, engine, settings) — those are not mods.

## Mod folder layout

A mod is just a folder inside `OpenBox/Mods/`. No installer, no registry, no build step. Edit the file, restart the game, it loads.

```text
OpenBox/
├── Game/
├── Maps/
│   └── sandbox/           # the only built-in map — do not add maps here
└── Mods/
    └── MyMod/
        ├── mod.json       # required — the only required file
        ├── scripts/
        ├── models/
        ├── sounds/
        ├── textures/
        └── maps/
```

Real examples in `~/workspace/openbox/Mods/`:

- `MyMap/` — enabled map mod
- `MyWeapon/` — enabled weapon mod
- `TestMod/` — disabled script mod (see Enable/disable below)

## mod.json

Every mod needs a `mod.json` at its root. Fields: `id`, `name`, `author`, `version`, `description`, `enabled`, `provides`.

Full example — copy of `Mods/MyMap/mod.json`:

```json
{
  "author": "You",
  "description": "Example map mod. Copy this folder, rename it, edit maps/my_map/map.json.",
  "enabled": true,
  "id": "my_map",
  "name": "My Map",
  "provides": ["maps"],
  "version": "1.0.0"
}
```

Other real examples:

`Mods/MyWeapon/mod.json` — `provides` is `["weapons"]`, `enabled` is `true`, `version` is `"1.0.0"`, description is `"Example weapon mod. See scripts/my_weapon.lua."`

`Mods/TestMod/mod.json` — `id` is `"test_mod"`, `name` is `"Test Mod"`, `version` is `"0.1.0"`, `enabled` is `false`, `provides` is `["scripts"]`, description is `"Example disabled mod. Toggle it ON in MODS."`

Rules for `mod.json`:

- `id` must be unique, lowercase, no spaces (e.g. `my_map`, `my_weapon`, `test_mod`).
- `provides` lists what the mod adds, e.g. `["maps"]`, `["weapons"]`, `["scripts"]`, or a combination such as `["maps", "weapons"]`.
- Keep `enabled` in sync with the in-game MODS screen (see Enable/disable below).

## map.json

### Layout

```text
MyMap/
├── mod.json
└── maps/
    └── my_map/
        ├── map.json
        └── assets/
```

OpenBox scans `Mods/*/maps/*/map.json` on startup. Every valid, enabled map appears in MAP SELECT automatically.

### Schema

Only `id` and `name` are required; the rest are optional.

| Field | Type | Meaning |
|---|---|---|
| `id` | string | Unique map id, matches the folder name (e.g. `my_map`, `sandbox`) |
| `name` | string | Display name in MAP SELECT (e.g. `"My Custom Map"`, `"Sandbox"`) |
| `author` | string | Who made it |
| `description` | string | One-line description |
| `version` | string | e.g. `"1.0.0"` |
| `spawn` | object | `{ "x": 0, "y": 1.7, "z": 8, "yaw": 0 }` — player start |
| `size` | object | `{ "x": 40, "z": 40 }` — floor size |
| `floor` | object | `{ "color": "#9a8f7a" }` — floor colour |
| `light` | object | `{ "sun": 1.0, "ambient": 0.6, "sky": "#a8c8e8" }` |
| `walls` | array | Each: `{ "x", "y", "z", "w", "h", "d" }` |
| `ramps` | array | Each: `{ "x", "y", "z", "w", "h", "d", "angle" }` |
| `props` | array | Each: `{ "type": "cube", "x", "y", "z" }` — `type` is `cube` or `barrel` |

### Full example — My Custom Map

Copy of `Mods/MyMap/maps/my_map/map.json` (pretty-printed, same values):

```json
{
  "author": "You",
  "description": "Example modded map. Small courtyard with a ramp and a wall.",
  "floor": { "color": "#9a8f7a" },
  "id": "my_map",
  "light": { "ambient": 0.6, "sky": "#a8c8e8", "sun": 1.0 },
  "name": "My Custom Map",
  "props": [
    { "type": "cube", "x": 5, "y": 1, "z": 0 },
    { "type": "barrel", "x": -5, "y": 1, "z": -2 }
  ],
  "ramps": [
    { "angle": -20, "d": 4, "h": 1.5, "w": 5, "x": -8, "y": 0.75, "z": 5 }
  ],
  "size": { "x": 40, "z": 40 },
  "spawn": { "x": 0, "y": 1.7, "yaw": 0, "z": 8 },
  "version": "1.0.0",
  "walls": [
    { "d": 1, "h": 4, "w": 30, "x": 0, "y": 2, "z": -15 },
    { "d": 30, "h": 4, "w": 1, "x": -15, "y": 2, "z": 0 },
    { "d": 30, "h": 4, "w": 1, "x": 15, "y": 2, "z": 0 },
    { "d": 1, "h": 3, "w": 8, "x": 0, "y": 1.5, "z": -5 }
  ]
}
```

### Reference — Sandbox (built-in, do not copy into Mods)

`Maps/sandbox/map.json`, the only built-in map: `id` `"sandbox"`, `name` `"Sandbox"`, `author` `"OpenBox"`, `floor` colour `"#8a8f98"`, `light` `{ "ambient": 0.6, "sky": "#87b5e0", "sun": 1.0 }`, `size` `{ "x": 60, "z": 60 }`, `spawn` `{ "x": 0, "y": 1.7, "yaw": 0, "z": 8 }`, `props` `[]`, two ramps (`angle` `-20` at `x: -12, z: 6` and `angle` `20` at `x: 12, z: 8`, both `w: 6, h: 1.5, d: 4, y: 0.75`), and five walls — the back wall `w: 40, h: 4, d: 1` at `z: -20`, side walls `w: 1, h: 4, d: 40` at `x: -20` and `x: 20`, plus a `w: 6, h: 3, d: 1` wall at `x: -10, z: -8` and a `w: 1, h: 3, d: 8` wall at `x: 12, z: -12`.

To make a new map, copy `Mods/MyMap/`, rename the folder, change `mod.json` (`id`, `name`, `description`), rename `maps/my_map/` to `maps/<your_id>/`, and edit that `map.json`. Keep it simple: flat floor, a few walls, a few ramps, a spawn point.

## Making maps inside the game — Map Builder (v0.1.5)

No files needed. HOME → COMMUNITY MAPS → BUILD A MAP:

1. Name the map.
2. Walk the flat arena. Pick a piece from the builder bar — wall, ramp, block, crate — and click in the arena to place it. One click places one piece. Undo removes the last piece.
3. Set the spawn point.
4. TEST PLAY loads the draft as a playable map so you can walk it before anyone else sees it.
5. SAVE puts it in My Maps. You can come back and edit a saved map later; DELETE removes it.

## Sharing maps — Community Maps (v0.1.5)

Anyone can publish a map, no accounts, no approval. From My Maps, pick a saved map and PUBLISH. It goes on the community board (HOME → COMMUNITY MAPS), where other players can browse it by name, author, date and size, DOWNLOAD it into their Map Select under Community, and PLAY it. A map.json file can also be imported and published the same way.

Rules for publishing — the game enforces all of these, so a map that breaks them is rejected with a plain message:

- **3 maps per week, per device.** The count is stored on your device; there are no accounts, and the game says so on the screen. After 3 publishes in a week, publishing is blocked until the next week.
- **Name max 40 characters, description max 120, author max 20.** Names, descriptions and author names are checked for bad words (including spaced-out and leetspeak forms) and for links — any URL (www, .com, .gg, discord, http, and similar) is rejected. Only letters, numbers, spaces and basic punctuation are allowed; HTML and emoji are rejected.
- **Map size and shape limits:** the map file must be 64 KB or smaller, with at most 120 boxes, 40 ramps and 60 props. Only the fields in the map.json schema above are allowed — extra fields are stripped or rejected, so nothing can be hidden inside a map file.
- **Community maps are single-player only.** Multiplayer stays on Sandbox.
- **Downloaded maps are checked again before they load.** A map is data only — it can never run code — and a tampered file is rejected instead of loading.
- **Report and Block Author:** every map on the board has a Report button (hides that map for you) and a Block Author option (hides all maps from that author for you). The game owner also keeps a ban list (`maps/blocked.json` on the site) that hides a map or author for everyone.

To make a map people will actually play: keep it simple — flat floor, a few walls, a few ramps, a clear spawn — test-play it first, and give it a name that says what it is.

## Lua API

Lua is the documented authoring format. The engine exposes one global, `OpenBox`. No build step.

```lua
OpenBox.RegisterWeapon("my_weapon")
OpenBox.RegisterEntity("my_entity")
OpenBox.RegisterMap("my_map")
OpenBox.RegisterProp("my_prop")
OpenBox.RegisterTool("my_tool")
```

| Call | Use for |
|---|---|
| `OpenBox.RegisterWeapon(id, props)` | Weapons (see below) |
| `OpenBox.RegisterEntity(id, props)` | Props / NPCs / stickmen — anything with health and physics |
| `OpenBox.RegisterMap(id, props)` | Maps (usually done via `map.json` instead) |
| `OpenBox.RegisterProp(id, props)` | Simple spawnable props |
| `OpenBox.RegisterTool(id, props)` | Tools (e.g. a grabber, a spawner) |

### Complete working weapon example

Copy of `Mods/MyWeapon/scripts/my_weapon.lua`:

```lua
-- My Weapon — example OpenBox mod script (Lua-style API)
-- Drop this mod folder into OpenBox/Mods/ and it appears in-game.
-- The game exposes the same API in JS; Lua files are the documented
-- authoring format and are loaded as simple registrations.

OpenBox.RegisterWeapon("my_weapon", {
  name = "My Weapon",
  damage = 15,
  magazine = 12,
  reserve = 60,
  fire_rate = 0.18,
  sound = "sounds/my_weapon_shot.wav",
})

OpenBox.RegisterEntity("my_entity", {
  name = "My Entity",
  health = 50,
  ragdoll = true,
})
```

Weapon props: `name` (display name), `damage` (per shot), `magazine` (rounds per mag — the built-in Glock 17 is 17), `reserve` (spare ammo), `fire_rate` (seconds between shots), `sound` (path under the mod folder, e.g. `sounds/my_weapon_shot.wav`).

Entity props: `name`, `health` (the example uses `50`), `ragdoll` (`true` for a stickman-style ragdoll that falls over when shot).

## How to add each type

### Maps

Two ways: build it in the game (Map Builder above — no files), or write the files:

1. Copy `Mods/MyMap/` to `Mods/<YourMap>/`.
2. Edit `mod.json` (`id`, `name`, `description`, `provides: ["maps"]`).
3. Rename `maps/my_map/` to `maps/<your_id>/` and edit `map.json` (see above).
4. Put map-specific files under `maps/<your_id>/assets/`.

### Props

- Add an entry to a map's `props` array: `{ "type": "cube", "x": 5, "y": 1, "z": 0 }` or `{ "type": "barrel", "x": -5, "y": 1, "z": -2 }`.
- Or register a new prop in a script: `OpenBox.RegisterProp("my_prop", { name = "My Prop" })`. It then appears in the Q spawn menu (PROPS section).

### Weapons

1. Create `Mods/<YourWeapon>/` with `mod.json` (`provides: ["weapons"]`).
2. Add `scripts/<your_weapon>.lua` with `OpenBox.RegisterWeapon(...)` as in the MyWeapon example.
3. Put the firing sound in `sounds/` and reference it as `sounds/<file>.wav` in the script.
4. The weapon appears in the Q spawn menu (WEAPONS section). The built-in Glock 17 is the reference: fire, reload with `R`, 17-round magazine, recoil, muzzle flash, firing sound, damages the stickman.

### NPCs

NPCs are entities — no advanced AI. Register one in a script:

```lua
OpenBox.RegisterEntity("my_npc", {
  name = "My NPC",
  health = 50,
  ragdoll = true,
})
```

The built-in stickman is the model: spawn from the Q menu, physics ragdoll, takes damage, falls over when shot, movable with physics. Do not add AI, pathfinding, or combat behaviour yet.

### Tools

Register in a script: `OpenBox.RegisterTool("my_tool", { name = "My Tool" })`. Keep a tool to one job (e.g. grab, spawn, measure).

### Models

Put model files under `models/` in the mod folder and reference them by relative path from the script or `map.json` that uses them. Use simple, low-poly models; the base game ships no model loader beyond the built-in cube / barrel / stickman shapes.

### Sounds

Put audio under `sounds/` and reference it as `sounds/<file>.wav` (see the weapon example). The base game uses synthesised sounds; a mod sound is just a file path in the registration.

### Scripts

Put Lua files under `scripts/`. One file, one job — e.g. `scripts/my_weapon.lua` registers one weapon (and, in the example, one entity). A script must only call the `OpenBox.Register*` functions listed above.

## Enable / disable

- In `mod.json`: `"enabled": true` loads the mod; `"enabled": false` skips it entirely — its maps, props and weapons do not load. `TestMod` ships with `"enabled": false` as the example.
- In game: HOME → MODS lists installed mods with `Enabled: ON` / `Enabled: OFF`. Toggling there flips the flag and the game saves the choice.
- If a mod is disabled, its map will not appear in MAP SELECT and its weapon/prop will not appear in the Q spawn menu. That is expected, not a bug.

## How to test

1. Put the mod folder in `OpenBox/Mods/` (PC layout), or use the MODS screen import in the web build to load a mod folder / single-file mod package.
2. Restart / reload the game. OpenBox scans `Mods/` on startup.
3. HOME → MODS: check the mod is listed and `Enabled: ON`.
4. HOME → PLAY → MAP SELECT: a map mod must appear there next to Sandbox. If it does not, see Troubleshooting.
5. Enter the map. Press `Q` (or `Tab`) for the spawn menu: a prop mod must appear under PROPS, a weapon mod under WEAPONS.
6. Spawn it, and for a weapon: click to fire, `R` to reload, shoot the stickman and check it falls over. For a prop/NPC: press `E` to grab / push it and check it moves with physics.
7. Test one thing at a time — one vertical slice (one map, or one weapon) all the way through before adding more.

Base-game controls for testing: WASD move, Shift sprint, Space jump, mouse look (click to capture the mouse; where pointer lock is blocked in the embedded view, moving the mouse looks directly), left click fire/grab, `R` reload, `E` grab/push, `Q`/`Tab` spawn menu, `Esc` pause/back.

## Rules

- **Do NOT hard-code custom maps into the base game.** The base game ships Sandbox and City built in; Farm ships as a bundled mod. Every other map is a mod in `Mods/`, or a Community Map published from the in-game Map Builder.
- **Keep mods small, one file one job.** One map per `map.json`, one weapon per script, one entity per registration.
- **No multiplayer, vehicles, advanced AI, campaigns, quests, or crafting yet.** The foundation is engine + Sandbox + Glock 17 + stickman + physics + menus + settings + mod system.
- **Desktop first.** VR is architecture-only: XR-enabled renderer + a WebXR (`navigator.xr`) support check, VR hands / grabbing / throwing / weapons later. Do not ship VR until desktop is stable.
- Settings (resolution, fullscreen, quality, master/effects volume, mouse sensitivity, key bindings) live in the base game, not in mods — do not try to override them from a mod.

## Troubleshooting

- **Map not appearing in MAP SELECT:** check in order — (1) `mod.json` is valid JSON and `enabled` is `true`; (2) the map file is at exactly `Mods/<Mod>/maps/<id>/map.json` (not `maps/map.json`, not `maps/<id>/maps/`); (3) `map.json` has `id` and `name` present and the `id` matches the folder name; (4) the mod is `Enabled: ON` in the MODS screen; (5) restart/reload the game so it re-scans `Mods/`.
- **Mod not listed in MODS at all:** `mod.json` is missing, malformed, or in the wrong folder — it must be at `Mods/<Mod>/mod.json`, and `id` must be unique.
- **Weapon / prop not in the Q spawn menu:** check `mod.json` `provides` includes `"weapons"` (or the prop type), `enabled` is `true`, the script is under `scripts/` and calls `OpenBox.RegisterWeapon` / `OpenBox.RegisterProp` with the exact id, and the mod was loaded after a restart.
- **Weapon fires but no sound:** check the `sound` path is `sounds/<file>.wav` relative to the mod folder and the file is actually in `sounds/`.
- **Map loads but spawn is wrong / player falls:** check `spawn` is `{ "x": 0, "y": 1.7, "z": 8, "yaw": 0 }` (or your own in-bounds coordinates) — `y: 1.7` is eye height, and the spawn must be inside `size` and not inside a wall.
- **JSON errors:** validate the file is strict JSON — no trailing commas, no comments, double quotes only. Compare against the MyMap / Sandbox examples above, field by field.
- **Still stuck:** strip the mod back to the MyMap or MyWeapon example, confirm that example loads, then change one thing at a time until it breaks.
