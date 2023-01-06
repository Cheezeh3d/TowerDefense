extends PathFollow2D

##create signal for base damage
signal base_damage(damage)
signal death()
signal adjust_money(reward)
##Set initial stats of enemy
var speed
var hp
var base_damage
var theName
#storing old position for getting angle
var old_pos

##Get certain nodes and sprites ready
onready var health_bar = get_node("HealthBar")
onready var impact_area = get_node("Impact")
var projectile_impact1 = preload("res://Scenes/Explosions/ProjectileImpact1/ProjectileImpact1.tscn")
var projectile_impact2 = preload("res://Scenes/Explosions/ProjectileImpact2/ProjectileImpact2.tscn")

##Function will run after scene is ready
func _ready():
	##Get the name of tank
	theName = get_name().substr(0, get_name().find("Tank")) + "Tank"
	##Set base variable data
	speed = GameData.enemy_data[theName]["speed"]
	hp = GameData.enemy_data[theName]["hp"]
	base_damage = GameData.enemy_data[theName]["base_damage"]
	##Set healthbar values
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)
	old_pos = position
	
##Will run every 1/60 second. Delta is time since last frame
func _physics_process(delta):
	##check if we have reached end of path.
	##unit_offset is predetermined property of PathFollow2D.
	##If unit_offset is 1.0, then we have reached end of path
	if unit_offset == 1.0:
		##Emit signal to apply damage to base
		emit_signal("base_damage", base_damage)
		##Get rid of this enemy
		emit_signal("death")
		on_destroy()
	##If we have not reached end
	else:
		##Move the enemy
		move(delta)
	
##Function to move enemy
func move(delta):
	##set_offset will move scene along set path
	##get_offset() cets the current offset as int
	##speed * delta will determine how far along the enemy
	##will have traveled this frame.
	set_offset(get_offset() + speed * delta)
	##rotate tank
	##look at a slightly older position as a vector
	##use look_at to auto-point enemy
	look_at(get_parent().to_global(Vector2(old_pos.x, old_pos.y)))
	##rotate 90 degrees. Otherwise, it would be facing backwards
	set_rotation_degrees(get_rotation_degrees() + 90)
	##Update old_pos for next iteration
	old_pos = position
	##Set healthbar so that it's always above tank
	##get sprite to get x height
	var theSpriteHeight = get_node("Sprite").texture.get_width()
	var theSpriteWidth = get_node("Sprite").texture.get_height()
	health_bar.set_position(position - Vector2(theSpriteHeight/2, 105 + (theSpriteWidth/2)))

##Called when we get hit
func on_hit(damage):
	##impact() will display explosion animation
	impact()
	##set new hp
	hp -= damage
	##change healthbar
	health_bar.value = hp
	##If we dead
	if hp<=0:
		##DESTORYYTYYYY
		emit_signal("death")
		emit_signal("adjust_money", GameData.enemy_data[theName]["reward"])
		on_destroy()
		
func on_destroy():
	for i in get_children():
		if i is KinematicBody2D:
			i.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	self.queue_free()

##function to display explosion animation
func impact():
	##get new seed
	randomize()
	##get random x y positions for explosion relative to tank sprite
	var x_pos = randi() % 23
	randomize()
	var y_pos = -(randi() % 23)
	##set impact locaction as vector
	var impact_location = Vector2(x_pos, y_pos)

	##create new impact instance, set it's position, and play random explosion
	if(randi() % 2 == 0):
		var new_impact = projectile_impact1.instance()
		new_impact.position = impact_location
		impact_area.add_child(new_impact)
	else:
		var new_impact = projectile_impact2.instance()
		new_impact.position = impact_location
		impact_area.add_child(new_impact)

