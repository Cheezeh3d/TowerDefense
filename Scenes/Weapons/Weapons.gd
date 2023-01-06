extends Node

##set variables
var type
var tier
var category
var enemy_array = []
var built = false
var enemy
var ready = true
var shotCounter = 0

func _ready():
	##If we are built yet
	if built && type != "DragTower":
		##Set range shape to be radius of range from GameData
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.weapon_data[type][tier]["range"]
		print(self.get_node("Range/CollisionShape2D").get_shape().radius)
		
func _physics_process(delta):
	##Check if there are enemies in our array and if we are built yet
	if enemy_array.size() != 0 and built:
		select_enemy()
		##Check that we aren't currently playing our animation
		if not get_node("AnimationPlayer").is_playing():
			##Turn weapon toward enemy
			turn()
		##If we are ready to fire
		if ready:
			##Fire weapon at enemy
			fire()
	else:
		enemy = null
		
##function for when we turn
func turn():
	##Get body and point it at enemy
	if not get_node("AnimationPlayer").is_playing():
		##Turn weapon toward enemy
		if not "Plane" in get_name():
			get_node("Body").look_at(enemy.position - Vector2(16, 132))
			print(get_node("Body").get_rotation_degrees())

		#get_node("Body").set_rotation_degrees(get_node("Body").get_rotation_degrees() - 45)
	
##function to select an enemy
func select_enemy():
	##Create empty arry
	var enemy_progress_array = []
	##Loop through enemy array
	for i in enemy_array:
		##Append offset of enemy compared to us
		enemy_progress_array.append(i.offset)
	##Find max offset in array
	var max_offset = enemy_progress_array.max()
	##Find that enemy with the max offset and store it
	var enemy_index = enemy_progress_array.find(max_offset)
	##Set enemy to that which has max offset compared to us
	enemy = enemy_array[enemy_index]
	
##function to fire
func fire():
	##set ready to false so teh game knows we are currently firing
	ready = false
	##Determine if we are firing projectile or missle, since they have different properties
	if category == "Projectile":
		fire_gun()
		##Tell enemy they have been hit
		was_hit()
	elif category == "Missile":
		fire_missile()
	yield(get_tree().create_timer(GameData.weapon_data[type][tier]["rof"]), "timeout")

	##Set ready to true
	ready = true
	
#function to kinda act as signal for when enemy was hit
func was_hit():
	if(is_instance_valid(enemy)):
		enemy.on_hit(GameData.weapon_data[type][tier]["damage"])

##fire gun
func fire_gun():
	get_node("AnimationPlayer").play("Fire")
	
##fire missile
func fire_missile():
	get_node("AnimationPlayer").play("Rocket")
	var missile = load("res://Scenes/Weapons/RocketLauncher/RocketLauncherT1/Rocket/Missile.tscn").instance()
	missile.connect("missile_hit_enemy", self, "was_hit")
	missile.rotation = get_node("Body").rotation
	missile.start(enemy)
	add_child(missile)

##Signal called when enemy enters our range
func _on_Range_body_entered(body):
	if "Tank" in body.get_parent().get_name():
		enemy_array.append(body.get_parent())
	
##Signal called when enemy exits our range
func _on_Range_body_exited(body):
	if "Tank" in body.get_parent().get_name():
		enemy_array.erase(body.get_parent())






