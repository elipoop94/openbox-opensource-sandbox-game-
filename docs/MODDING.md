# OpenBox modding — keep it simple

## 1. A mod is a folder

```
Mods/
  MyMod/
    mod.json
    scripts/
    models/
    sounds/
    textures/
    maps/
```

`mod.json` — the only required file:

```json
{
  "id": "my_mod",
  "name": "My Mod",
  "author": "You",
  "version": "1.0.0",
  "description": "What it adds.",
  "enabled": true,
  "provides": ["maps", "weapons"]
}
```

Enabled/disabled is just that `enabled` flag. The MODS screen toggles it, and the game saves the choice. A disabled mod's maps, props, and weapons do not load.

## 2. Add a map

```
MyMap/
  mod.json
  maps/
    my_map/
      map.json
      assets/
```

`map.json` fields (all optional except `id` and `name`):

```json
{
  "id": "my_map",
  "name": "My Custom Map",
  "spawn": { "x": 0, "y": 1.7, "z": 8, "yaw": 0 },
  "size": { "x": 40, "z": 40 },
  "floor": { "color": "#9a8f7a" },
  "light": { "sun": 1.0, "ambient": 0.6, "sky": "#a8c8e8" },
  "walls": [{ "x": 0, "y": 2, "z": -15, "w": 30, "h": 4, "d": 1 }],
  "ramps": [{ "x": -8, "y": 0.75, "z": 5, "w": 5, "h": 1.5, "d": 4, "angle": -20 }],
  "props": [{ "type": "cube", "x": 5, "y": 1, "z": 0 }]
}
```

On startup OpenBox scans `Mods/*/maps/*/map.json`. Every valid, enabled map appears in MAP SELECT automatically. Nothing is hard-coded — the base game only ships `Sandbox` (`Maps/sandbox/map.json`).

In the web build, use the in-game MODS screen's "Load mod map (JSON)" / example-mod loader to try the bundled examples (My Custom Map, Test Facility, City Map). The file layout above is the PC layout; the JSON format is identical.

## 3. Add a prop, weapon, NPC, or tool

Same pattern — a folder + `mod.json` + a script:

```lua
OpenBox.RegisterWeapon("my_weapon")
OpenBox.RegisterEntity("my_entity")
OpenBox.RegisterMap("my_map")
```

Full example (`Mods/MyWeapon/scripts/my_weapon.lua`):

```lua
OpenBox.RegisterWeapon("my_weapon", {
  name = "My Weapon",
  damage = 15,
  magazine = 12,
  reserve = 60,
  fire_rate = 0.18,
  sound = "sounds/my_weapon_shot.wav",
})
```

Registerable things: Maps, Props, Weapons, NPCs, Tools, Models, Sounds, Scripts. Keep each one small — one file, one job.

## 4. Scripting

Lua is the documented authoring format. The engine exposes one global:

- `OpenBox.RegisterWeapon(id, props)`
- `OpenBox.RegisterEntity(id, props)` — props / NPCs / stickmen
- `OpenBox.RegisterMap(id, props)`
- `OpenBox.RegisterProp(id, props)`
- `OpenBox.RegisterTool(id, props)`

No build step. Edit the file, restart the game, it loads.

## 5. VR / OpenXR — architecture only

Desktop is fully functional first. The code is structured so VR can be added without rewriting the game:

- Input is one abstraction: mouse+keyboard today, XR controllers later (`OpenBox.Input`).
- Interaction is one abstraction: raycast + grab + use (`OpenBox.Interact`).
- Weapons are one abstraction: fire / reload / recoil (`OpenBox.Weapon`).
- Physics objects are plain bodies with position/velocity — no desktop-only assumptions.

Eventually: VR hands, grabbing, throwing, physics interaction, using weapons, via WebXR / OpenXR. The game checks `navigator.xr` at startup and shows a VR button only when a headset is available. Do not ship VR until desktop is stable.
