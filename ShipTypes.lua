local Standard = require('ship_types/Standard')
local Assault = require('ship_types/Assault')
local Gunship = require('ship_types/Gunship')
local Ray = require('ship_types/Ray')
local Zap = require('ship_types/Zap')
local Charge = require('ship_types/Charge')
local Missile = require('ship_types/Missile')

ShipType = {
  standard = {
    name = "Standard",
    actionHandler = Standard,
    description = "Balanced speed, range, and damage",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 20,
    fireRate = 12,
    health = 150,
    weaponDamage = 10,
    frameOffset = 0,
    previousType = "carrier",
    nextType = "gunship"
  },
  gunship = {
    name = "Gunship",
    actionHandler = Gunship,
    description = "Can fire a long range attack in any direction, at the cost of speed and defence",
    topSpeed = 120,
    acceleration = 180,
    rotationSpeed = 5,
    cannonRotation = 0,
    fireRate = 1.5,
    health = 130,
    weaponDamage = 40,
    frameOffset = 2,
    previousType = "standard",
    nextType = "assalt"
  },
  assalt = {
    name = "Assault",
    actionHandler = Assault,
    description = "High speed and damage at the cost of attack range",
    topSpeed = 300,
    acceleration = 240,
    rotationSpeed = 3,
    fireRate = 1,
    health = 170,
    weaponDamage = 10,
    frameOffset = 4,
    previousType = "gunship",
    nextType = "ray"
  },
  ray = {
    name = "Ray",
    actionHandler = Ray,
    description = "Medium attack range with instant damage",
    topSpeed = 180,
    acceleration = 240,
    rotationSpeed = 4,
    fireRate = 10,
    health = 150,
    weaponDamage = 1.5,
    frameOffset = 6,
    previousType = "assalt",
    nextType = "zap"
  },
  zap = {
    name = "Zapper",
    actionHandler = Standard,
    description = "High short range damage at the cost of defence",
    topSpeed = 180,
    acceleration = 180,
    rotationSpeed = 5,
    fireRate = 2,
    health = 160,
    weaponDamage = 3,
    frameOffset = 8,
    previousType = "ray",
    nextType = "charge"
  },
  charge = {
    name = "Charger",
    actionHandler = Standard,
    description = "Can charge attack extra damage and range",
    topSpeed = 240,
    acceleration = 240,
    rotationSpeed = 4,
    fireRate = 2,
    health = 160,
    weaponDamage = 20,
    frameOffset = 10,
    previousType = "zap",
    nextType = "missile"
  },
  missile = {
    name = "Missile",
    actionHandler = Standard,
    description = "Fires missiles that home in on enemies",
    topSpeed = 180,
    acceleration = 180,
    rotationSpeed = 4,
    fireRate = 2,
    health = 150,
    weaponDamage = 70,
    frameOffset = 12,
    previousType = "charge",
    nextType = "carrier"
  },
  carrier = {
    name = "Carrier",
    actionHandler = Standard,
    description = "Launches drone that attack enemies",
    topSpeed = 120,
    acceleration = 120,
    rotationSpeed = 4,
    fireRate = 1,
    health = 150,
    weaponDamage = 10,
    frameOffset = 14,
    previousType = "Missile",
    nextType = "standard"
  }
}


-- ideas

-- Assault - fires a shotgun blast
-- Standard - fires bullets in an alternating stream
-- Gunship - fires bullets in any direction
-- Ray - fires a beam that
-- Zap - Short range aoe cone attack
-- Flack - fires short range exposions that block incoming attacks
-- Missile - fires a homing Missile
-- Boomerang - fires a single boomerange that will return to the player after a short diration or when it hits something
-- Bomber - fires and gernade that explodes when it hits a wall, player, or after a short duration
-- Phaser - warps a short distance doing damage to the the space it warped through
-- Railgun - fires a bullet that can travel through walls
-- Bouncer - fires bullets that bounch off the walls
-- Carrier - control 3 fighter that will attack nearby enemies
-- Turret - deploy a turret that will fire at ships nearby
-- Spreader - fires a spreadshot of 3-5 bullets
-- Vortex - ship fires bullets that spin outward in a circle
-- Charge - can hold down attack to charge a move powerful bullet
-- Shockwave - does AOE damage around the ship
-- GunAndShield - when firing you have a shield in that dirrection
-- Control - fire a projectile you can control trigger explosions
-- sapper - fires a bullet that does damage over time







