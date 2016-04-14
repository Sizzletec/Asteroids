local Standard = require('ship_types/Standard')
local Assault = require('ship_types/Assault')
local Gunship = require('ship_types/Gunship')
local Ray = require('ship_types/Ray')
local Zap = require('ship_types/Zap')
local Charge = require('ship_types/Charge')
local Missile = require('ship_types/Missile')
local Miner = require('ship_types/Miner')
local Spreader = require('ship_types/Spreader')
local Phaser = require('ship_types/Phaser')
local Shockwave = require('ship_types/Shockwave')
local Bounce = require('ship_types/Bounce')
local Vortex = require('ship_types/Vortex')

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
    previousType = "vortex",
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
    fireRate = 20,
    health = 150,
    weaponDamage = 3,
    frameOffset = 6,
    previousType = "assalt",
    nextType = "zap"
  },
  zap = {
    name = "Zapper",
    actionHandler = Zap,
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
    actionHandler = Charge,
    description = "Can charge attack extra damage and range",
    topSpeed = 240,
    acceleration = 240,
    rotationSpeed = 4,
    fireRate = 4,
    health = 160,
    weaponDamage = 20,
    frameOffset = 10,
    previousType = "zap",
    nextType = "missile"
  },
  missile = {
    name = "Missile",
    actionHandler = Missile,
    description = "Fires missiles that home in on enemies",
    topSpeed = 180,
    acceleration = 180,
    rotationSpeed = 4,
    fireRate = 1,
    health = 150,
    weaponDamage = 30,
    frameOffset = 12,
    previousType = "charge",
    nextType = "miner"
  },
  miner = {
    name = "Miner",
    actionHandler = Miner,
    description = "Drops a powerful mine that explodes",
    topSpeed = 200,
    acceleration = 200,
    rotationSpeed = 4,
    fireRate = 1,
    health = 150,
    weaponDamage = 10,
    frameOffset = 14,
    previousType = "missile",
    nextType = "spreader"
  },
  spreader = {
    name = "Spreader",
    actionHandler = Spreader,
    description = "Fires a spreadshot",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    fireRate = 4,
    health = 150,
    weaponDamage = 5,
    frameOffset = 0,
    previousType = "miner",
    nextType = "phaser"
  },
  phaser = {
    name = "Phaser",
    actionHandler = Phaser,
    description = "Warps a short distance and deals damage",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    fireRate = 1,
    health = 150,
    weaponDamage = 100,
    frameOffset = 0,
    previousType = "spreader",
    nextType = "standard"
  },
  shockwave = {
    name = "Shockwave",
    actionHandler = Shockwave,
    description = "Deal AOE damage around the ship and slow them",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    fireRate = 1,
    health = 150,
    weaponDamage = 100,
    frameOffset = 0,
    previousType = "phaser",
    nextType = "bounce"
  },
  bounce = {
    name = "Bounce",
    actionHandler = Bounce,
    description = "bullets bounce off walls",
    topSpeed = 200,
    acceleration = 260,
    rotationSpeed = 5,
    fireRate = 2,
    health = 150,
    weaponDamage = 20,
    frameOffset = 0,
    previousType = "shockwave",
    nextType = "standard"
  },
  vortex = {
    name = "Vortex",
    actionHandler = Vortex,
    description = "shoots 4 bullet that spin outward in a circle",
    topSpeed = 200,
    acceleration = 260,
    rotationSpeed = 5,
    fireRate = 10,
    health = 150,
    weaponDamage = 20,
    frameOffset = 0,
    previousType = "bounce",
    nextType = "standard"
  },
}


-- basic functionality

-- Assault - fires a shotgun blast
-- Standard - fires bullets in an alternating stream
-- Gunship - fires bullets in any direction
-- Ray - fires a beam that
-- Zap - Short range aoe cone attack
-- Missile - fires a homing Missile
-- Spreader - fires a spreadshot of 3-5 bullets
-- Charge - can hold down attack to charge a move powerful bullet
-- Phaser - warps a short distance doing damage to the the space it warped through
-- Shockwave - does AOE damage around the ship
-- Bouncer - fires bullets that bounch off the walls
-- Vortex - ship fires bullets that spin outward in a circle

-- ideas


-- Flack - fires short range exposions that block incoming attacks
-- Boomerang - fires a single boomerange that will return to the player after a short diration or when it hits something
-- Bomber - fires and gernade that explodes when it hits a wall, player, or after a short duration
-- Railgun - fires a bullet that can travel through walls
-- Carrier - control 3 fighter that will attack nearby enemies
-- Turret - deploy a turret that will fire at ships nearby
-- Vortex - ship fires bullets that spin outward in a circle
-- GunAndShield - when firing you have a shield in that dirrection
-- Control - fire a projectile you can control trigger explosions
-- Miner - drops mines that explod when a ship runs into them or after a short duration
-- sapper - fires a bullet that does damage over time



-- level ideas

-- Healing zone
-- Pistons
-- Gate (hit button to open)
-- bridge (multi layer stage)
-- explosive blocks that come back
-- breakable blocks that come back
-- shield block that fail after x damage



-- general

-- Battle with a variety of ships in a 4 player arena battle
-- Team battle
-- Astroid style movement
-- single or co-op missions
-- Ship hanger where you can walk around between the ships(get in a ship)
-- 5 - 10 good playable ships
-- Levels moves from scene to scene with moving section in between
-- return to a hanger between levels
-- on foot sections
-- can board enemy ships and steal there fighters(one way to aquire new ships)







