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
