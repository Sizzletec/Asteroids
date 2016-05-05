ShipType = {
  standard = {
    name = "Standard",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 8,
    health = 150,
    frameOffset = 0,
    previousType = "vortex",
    nextType = "gunship"
  },
  gunship = {
    name = "Gunship",
    topSpeed = 120,
    acceleration = 180,
    rotationSpeed = 5,
    health = 130,
    frameOffset = 2,
    previousType = "standard",
    nextType = "assalt"
  },
  assalt = {
    name = "Assault",
    topSpeed = 300,
    acceleration = 400,
    rotationSpeed = 5,
    health = 170,
    frameOffset = 4,
    previousType = "gunship",
    nextType = "ray"
  },
  ray = {
    name = "Ray",
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
    topSpeed = 240,
    acceleration = 240,
    rotationSpeed = 4,
    health = 160,
    frameOffset = 10,
    previousType = "zap",
    nextType = "missile"
  },
  missile = {
    name = "Missile",
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
    topSpeed = 200,
    acceleration = 200,
    rotationSpeed = 4,
    health = 150,
    frameOffset = 14,
    previousType = "missile",
    nextType = "spreader"
  },
  spreader = {
    name = "Spreader",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    health = 150,
    frameOffset = 0,
    previousType = "miner",
    nextType = "phaser"
  },
  phaser = {
    name = "Phaser",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    health = 150,
    frameOffset = 0,
    previousType = "spreader",
    nextType = "standard"
  },
  shockwave = {
    name = "Shockwave",
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    fireRate = 1,
    health = 150,
    frameOffset = 0,
    previousType = "phaser",
    nextType = "bounce"
  },
  bounce = {
    name = "Bounce",
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
    topSpeed = 200,
    acceleration = 260,
    rotationSpeed = 5,
    fireRate = 1,
    health = 150,
    weaponDamage = 40,
    frameOffset = 0,
    previousType = "bounce",
    nextType = "standard"
  },
}