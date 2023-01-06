extends Node

var enemy_data = {
	"BlueTank": {
		"speed": 100,
		"hp": 75,
		"base_damage": 5,
		"reward": 1
	},
	"RedTank": {
		"speed": 100,
		"hp": 100,
		"base_damage": 7,
		"reward": 2
	},
	"GreenTank": {
		"speed": 150,
		"hp": 125,
		"base_damage": 7,
		"reward": 5
	},
	"SandTank": {
		"speed": 400,
		"hp": 25,
		"base_damage": 15,
		"reward": 10
	},
	"DarkTank": {
		"speed": 200,
		"hp": 200,
		"base_damage": 20,
		"reward": 20
	},
	"BigRedTank": {
		"speed": 70,
		"hp": 500,
		"base_damage": 35,
		"reward": 40
	},
	"BigDarkTank": {
		"speed": 40,
		"hp": 1000,
		"base_damage": 75,
		"reward": 80
	},
	"HugeTank": {
		"speed": 30,
		"hp": 1500,
		"base_damage": 90,
		"reward": 160
	}
}

var weapon_data = {
	"Turret":{
		"T1":{
			"damage": 20,
			"rof": 1,
			"range": 350,
			"category": "Projectile",
			"cost": 2
		},
		"T2":{
			"damage": 30,
			"rof": 2,
			"range": 350,
			"category": "Projectile",
			"cost": 2
		}
	},
	"RocketLauncher":{
		"T1":{
			"damage": 50,
			"rof": 1,
			"range": 600,
			"category": "Missile",
			"cost": 15
		},
		"T2":{
			"damage": 100,
			"rof": 2,
			"range": 800,
			"category": "Missile",
			"cost": 20
		}
	},
	"Plane":{
		"T1":{
			"damage": 15,
			"rof": 0.5,
			"range": 800,
			"category": "Projectile",
			"cost": 40
		},
		"T2":{
			"damage": 30,
			"rof": 0.5,
			"range": 800,
			"category": "Projectile",
			"cost": 40
		}
	},
	"Gunner":{
		"T1":{
			"damage": 5,
			"rof": 0.05,
			"range": 200,
			"category": "Projectile",
			"cost": 80
		},
		"T2":{
			"damage": 10,
			"rof": 0.05,
			"range": 200,
			"category": "Projectile",
			"cost": 90
		}
	}
}
