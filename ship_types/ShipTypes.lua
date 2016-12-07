require('components/ship/AlternatingFireComponent')
require('components/ship/ShotgunComponent')
require('components/ship/VortexComponent')
require('components/ship/BounceComponent')
require('components/ship/ChargeAttackComponent')
require('components/ship/AlternatingMissileComponent')
require('components/ship/MineComponent')
require('components/ship/PhaseComponent')
require('components/ship/ShockwaveComponent')
require('components/ship/SpreadShotComponent')
require('components/ship/SelfDestructComponent')
require('components/ship/ZapComponent')
require('components/ship/RotatingFireComponent')
require('components/ship/RayComponent')
require('components/ship/BoostComponent')
require('components/ship/RocketShotComponent')
require('components/ship/GrenadeComponent')
require('components/ship/IonComponent')
require('components/ship/ShieldDropComponent')

ShipType = {
  standard = {
    name = "Standard",
    primaryAttack = AlternatingFireComponent,
    secondaryAttack = ShieldDropComponent,
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 8,
    health = 150,
    frameOffset = 0
  },
  gunship = {
    name = "Gunship",
    primaryAttack = RotatingFireComponent,
    secondaryAttack = VortexComponent,
    topSpeed = 120,
    acceleration = 180,
    rotationSpeed = 5,
    health = 130,
    frameOffset = 2
  },
  assalt = {
    name = "Assault",
    primaryAttack = ShotgunComponent,
    secondaryAttack = PhaseComponent,
    topSpeed = 300,
    acceleration = 400,
    rotationSpeed = 5,
    health = 170,
    frameOffset = 4
  },
  ray = {
    name = "Ray",
    primaryAttack = RayComponent,
    secondaryAttack = PhaseComponent,
    topSpeed = 180,
    acceleration = 240,
    rotationSpeed = 4,
    health = 150,
    frameOffset = 6
  },
  zap = {
    name = "Zapper",
    primaryAttack = ZapComponent,
    secondaryAttack = IonComponent,
    topSpeed = 240,
    acceleration = 300,
    rotationSpeed = 5,
    health = 160,
    frameOffset = 8
  },
  charge = {
    name = "Charger",
    primaryAttack = ChargeAttackComponent,
    secondaryAttack = IonComponent,
    topSpeed = 240,
    acceleration = 240,
    rotationSpeed = 4,
    health = 160,
    frameOffset = 10
  },
  missile = {
    name = "Missile",
    primaryAttack = AlternatingMissileComponent,
    secondaryAttack = PhaseComponent,
    topSpeed = 180,
    acceleration = 180,
    rotationSpeed = 4,
    health = 150,
    frameOffset = 12
  },
  miner = {
    name = "Miner",
    primaryAttack = MineComponent,
    secondaryAttack = PhaseComponent,
    topSpeed = 200,
    acceleration = 200,
    rotationSpeed = 4,
    health = 300,
    frameOffset = 14
  },
  spreader = {
    name = "Spreader",
    primaryAttack = SpreadShotComponent,
    secondaryAttack = PhaseComponent,
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    health = 150,
    frameOffset = 0
  },
  rocket = {
    name = "Rocket",
    primaryAttack = RocketShotComponent,
    secondaryAttack = IonComponent,
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    health = 150,
    frameOffset = 16
  },
  -- phaser = {
  --   name = "Phaser",
  --   primaryAttack = PhaseComponent,
  --   secondaryAttack = PhaseComponent,
  --   topSpeed = 240,
  --   acceleration = 360,
  --   rotationSpeed = 10,
  --   health = 150,
  --   frameOffset = 0
  -- },
  shockwave = {
    name = "Shockwave",
    primaryAttack = ShockwaveComponent,
    secondaryAttack = PhaseComponent,
    topSpeed = 240,
    acceleration = 360,
    rotationSpeed = 10,
    health = 150,
    frameOffset = 0
  },
  bounce = {
    name = "Bounce",
    primaryAttack = BounceComponent,
    secondaryAttack = GrenadeComponent,
    topSpeed = 200,
    acceleration = 260,
    rotationSpeed = 5,
    health = 150,
    frameOffset = 0
  },
  vortex = {
    name = "Vortex",
    primaryAttack = VortexComponent,
    secondaryAttack = PhaseComponent,
    topSpeed = 200,
    acceleration = 260,
    rotationSpeed = 5,
    health = 150,
    frameOffset = 18
  },
}

ShipSelectOrder = {
  ShipType.standard,
  ShipType.gunship,
  ShipType.assalt,
  -- ShipType.ray,
  ShipType.zap,
  ShipType.charge,
  ShipType.rocket,
  -- ShipType.missile,
  ShipType.miner,
  ShipType.spreader,
  -- ShipType.phaser,
  ShipType.shockwave,
  ShipType.bounce,
  ShipType.vortex
}
