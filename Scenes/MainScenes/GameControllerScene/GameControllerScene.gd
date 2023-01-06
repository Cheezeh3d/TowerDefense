extends Node2D

##create signal
signal game_finished(result)

##Store map
var map_node

##save build information
var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type
var the_wave = []

##save base health
var base_health = 100

##save money (at start, player has 4 by default)
var money = 4

##save wave information
var current_wave = 0
var enemies_in_wave = 0

func _ready():
	set_process_input(true)
	get_node("HUD/ViewportContainer").connect("theInput", self, "theInput")
	map_node = get_node("HUD/ViewportContainer/Viewport/MapOne") ##change later
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	
func _process(delta):
	if build_mode:
		update_tower_preview()
		
func get_money():
	return money
	
func set_money(new_money):
	money += new_money
	
func get_current_wave():
	return current_wave

func theInput(event):
	if event == "ui_cancel" and build_mode == true:
		cancel_build_mode()
	if event == "ui_accept" and build_mode == true:
		verify_and_build()
		cancel_build_mode()

##Will be called when we start the next wave
func start_next_wave():
	##set buttons
	get_node("HUD/IconContainer/StartWaveButton").visible = false
	get_node("HUD/IconContainer/PausePlay").visible = true
	get_node("HUD/IconContainer/SpeedButton").visible = true
	##get enemies in wave
	var wave_data = retrieve_wave_data()
	##short timer to process stuff
	yield(get_tree().create_timer(0.2), "timeout")
	##spawn them enemies
	spawn_enemies(wave_data)

##Will get enemies in wave, set current_wave/enemies_in_wave, and return enemies in wave
func retrieve_wave_data():
	current_wave += 1
	##Create array to store enemies
	var wave_data = []
	##Use for loops to append certain amount of each enemy based on wave number
	for i in current_wave:
		wave_data.append(["BlueTank", 2])
	if floor(current_wave / 5) != 0:
		for i in ((current_wave - 4) + (floor(current_wave / 2))):
			wave_data.append(["RedTank", 0.1])
	if floor(current_wave / 10) != 0:
		for i in ((current_wave - 9) + (floor(current_wave / 3))):
			wave_data.append(["GreenTank", 0.1])
	if floor(current_wave / 15) != 0:
		for i in ((current_wave - 14) + (floor(current_wave / 4))):
			wave_data.append(["SandTank", 0.1])
	if floor(current_wave / 20) != 0:
		for i in ((current_wave - 19) + (floor(current_wave / 5))):
			wave_data.append(["DarkTank", 0.1])
	if floor(current_wave / 25) != 0:
		for i in ((current_wave - 24) + (floor(current_wave / 6))):
			wave_data.append(["BigRedTank", 0.1])
	if floor(current_wave / 30) != 0:
		for i in ((current_wave - 29) + (floor(current_wave / 7))):
			wave_data.append(["BigDarkTank", 0.1])
	if floor(current_wave / 35) != 0:
		for i in ((current_wave - 34) + (floor(current_wave / 8))):
			wave_data.append(["HugeTank", 0.1])
	##Shuffle array
	randomize()
	wave_data.shuffle()
	enemies_in_wave = wave_data.size()
	the_wave = wave_data
	return wave_data
	
##function to spawn enemies from wave
func spawn_enemies(wave_data):
	#iterate through array of enemies
	var iteration = 1
	for i in wave_data:
		##load enemy
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + "/" + i[0] + ".tscn").instance()
		new_enemy.connect("base_damage", self, "on_base_damage")
		new_enemy.connect("adjust_money", self, "set_money")
		if iteration == wave_data.size():
			new_enemy.connect("death", self, "end_of_wave")
		#loop through all children and get num of paths
		var counter = 0
		for j in map_node.get_children():
			if j.get_class() == "Path2D":
				counter += 1
		##set path
		randomize()
		var path = "path" + str(randi() % counter + 1)
		map_node.get_node(path).add_child(new_enemy, true)
		##create timer to space out enemies
		yield(get_tree().create_timer(i[1]), "timeout")
		iteration += 1

##when we take base damage, this is called
func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
	else:
		get_node("HUD").update_health_bar(base_health)

##function to initiate build mode
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	else:
		build_type = tower_type + "T1"
		build_mode = true
		get_node("HUD").set_tower_preview(build_type, get_global_mouse_position())

##used to set preview sprite when placing item
func update_tower_preview():
	##Get mouse position
	var mouse_position = get_node("HUD/ViewportContainer/Viewport").get_mouse_position() + Vector2(0, 100)
	##Get the tile the mouse is on and the tile's position
	var current_tile = map_node.get_node("path_tilemap").world_to_map(mouse_position)
	var tile_position = map_node.get_node("path_tilemap").map_to_world(current_tile)- Vector2(0, 100)
	
	##If there isn't anything on this tile
	if map_node.get_node("path_tilemap").get_cellv(current_tile) == -1 && GameData.weapon_data[build_type.substr(0, build_type.length() - 2)][build_type.substr(build_type.length() - 2, 2)]["cost"] <= money:
		get_node("HUD").update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	##If not
	else:
		get_node("HUD").update_tower_preview(tile_position, "adff4545")
		build_valid = false
	
##Function to cancel build mode
func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("HUD/ViewportContainer/TowerPreview").free()
	
##build turret on spot if valid
func verify_and_build():
	if build_valid && GameData.weapon_data[build_type.substr(0, build_type.length() - 2)][build_type.substr(build_type.length() - 2, 2)]["cost"] <= money:
		##get tower
		var new_tower = load("res://Scenes/Weapons/" + 
		build_type.substr(0, build_type.length() - 2) + 
		"/" + 
		build_type + 
		"/" + 
		build_type + ".tscn").instance()
		##set stuff
		new_tower.position = build_location + Vector2(32, 132)
		new_tower.built = true
		new_tower.type = build_type.substr(0, build_type.length() - 2)
		new_tower.tier = build_type.substr(build_type.length() - 2, 2)
		new_tower.category = GameData.weapon_data[build_type.substr(0, build_type.length() - 2)][build_type.substr(build_type.length() - 2, 2)]["category"]
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("path_tilemap").set_cellv(build_tile, 5)
		money -= GameData.weapon_data[build_type.substr(0, build_type.length() - 2)][build_type.substr(build_type.length() - 2, 2)]["cost"]
		
		
##function to set next wave up after wave is over
func end_of_wave():
	##set buttons
	get_node("HUD/IconContainer/StartWaveButton").visible = true
	get_node("HUD/IconContainer/PausePlay").visible = false
	get_node("HUD/IconContainer/SpeedButton").visible = false
	
