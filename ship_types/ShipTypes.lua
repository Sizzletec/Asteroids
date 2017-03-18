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
require('components/ship/ShieldingComponent')



ShipType = {
  standard = {
    name = "Standard",
    primaryAttack = AlternatingFireComponent,
    secondaryAttack = RocketShotComponent,
    tertiaryAttack = MineComponent,
    quaternaryAttack = BoostComponent,
    topSpeed = 180,
    acceleration = 360,
    rotationSpeed = 8,
    health = 150,
    frameOffset = 18  
  },
  gunship = {
    name = "Gunship",
    primaryAttack = RotatingFireComponent,
    secondaryAttack = VortexComponent,
    tertiaryAttack = MineComponent,
    quaternaryAttack =  PhaseComponent,
    topSpeed = 120,
    acceleration = 180,
    rotationSpeed = 5,
    health = 130,
    frameOffset = 2
  },
  assalt = {
    name = "Assault",
    primaryAttack = ShotgunComponent,
    secondaryAttack = ShieldingComponent,
    tertiaryAttack = BoostComponent,
    quaternaryAttack = PhaseComponent,
    topSpeed = 220,
    acceleration = 400,
    rotationSpeed = 6,
    health = 170,
    frameOffset = 4
  },
  ray = {
    name = "Ray",
    primaryAttack = RayComponent,
    secondaryAttack = IonComponent,
    tertiaryAttack = ShockwaveComponent,
    quaternaryAttack =  BoostComponent,
    topSpeed = 180,
    acceleration = 200,
    rotationSpeed = 4,
    health = 150,
    frameOffset = 6
  },
  zap = {
    name = "Zapper",
    primaryAttack = ZapComponent,
    secondaryAttack = IonComponent,
    tertiaryAttack = BoostComponent,
    quaternaryAttack =  PhaseComponent,
    topSpeed = 240,
    acceleration = 300,
    rotationSpeed = 5,
    health = 160,
    frameOffset = 8
  },
  charge = {
    name = "Charger",
    primaryAttack = ChargeAttackComponent,
    secondaryAttack = GrenadeComponent,
    tertiaryAttack = MineComponent,
    quaternaryAttack =  BoostComponent,
    topSpeed = 240,
    acceleration = 240,
    rotationSpeed = 4,
    health = 160,
    frameOffset = 10
  }
}

ShipSelectOrder = {
  ShipType.standard,
  ShipType.gunship,
  ShipType.assalt,
  ShipType.ray,
  ShipType.zap,
  ShipType.charge,
}
