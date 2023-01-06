extends Control

##set variables to hold connections to hp bar
onready var hp_bar = get_parent().get_node("HUD/IconContainer/HP")
onready var hp_bar_tween = get_parent().get_node("HUD/IconContainer/HP/Tween")
onready var money_text = get_parent().get_node("HUD/IconContainer/CashAmount")

func _process(delta):
	money_text.set_text(str(get_parent().get_money()))
	if get_parent().get_money() >= GameData.weapon_data["Turret"]["T1"]["cost"]:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/Turret/TextureRect2").visible = false
	else:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/Turret/TextureRect2").visible = true
		
	if get_parent().get_money() >= GameData.weapon_data["RocketLauncher"]["T1"]["cost"]:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/RocketLauncher/TextureRect2").visible = false
	else:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/RocketLauncher/TextureRect2").visible = true
		
	if get_parent().get_money() >= GameData.weapon_data["Plane"]["T1"]["cost"]:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/Plane/TextureRect2").visible = false
	else:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/Plane/TextureRect2").visible = true
		
	if get_parent().get_money() >= GameData.weapon_data["Gunner"]["T1"]["cost"]:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/Gunner/TextureRect2").visible = false
	else:
		get_parent().get_node("HUD/IconContainer/ScrollContainer/ShopContainer/Gunner/TextureRect2").visible = true

##function to set preview of selected tower before we place it
func set_tower_preview(tower_type, mouse_position):
	##get connection to tower instance
	var drag_tower = load("res://Scenes/Weapons/" + tower_type.substr(0, tower_type.length() - 2) + "/" + tower_type + "/" + tower_type + ".tscn").instance()
	##set name of this specific tower
	drag_tower.set_name("DragTower")
	##modulate it's color a lil bit
	drag_tower.modulate = Color("ad54ff3c")
	
	##create new sprite for range
	var range_texture = Sprite.new()
	##set position to match turret
	range_texture.position = Vector2(32, 32)
	##scale it
	var scaling = GameData.weapon_data[tower_type.substr(0, tower_type.length() - 2)][tower_type.substr(tower_type.length() - 2, 2)]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	##load texture
	var texture = load("res://Assets/UI/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	##Add tower to tree
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	get_node("ViewportContainer").add_child(control, true)
	move_child(get_node("ViewportContainer"), 0)
	
func update_tower_preview(new_position, color):
	get_node("ViewportContainer/TowerPreview").rect_position = new_position
	if get_node("ViewportContainer/TowerPreview/DragTower").modulate != Color(color):
		get_node("ViewportContainer/TowerPreview/DragTower").modulate = Color(color)
		get_node("ViewportContainer/TowerPreview/Sprite").modulate = Color(color)
		
##If pause/play is pressed
func _on_PausePlay_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().current_wave == 0:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true


func _on_SpeedButton_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 3.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(3.0)
		
func update_health_bar(base_health):
	print("called")
	hp_bar_tween.interpolate_property(hp_bar, 'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >= 60:
		hp_bar.set_tint_progress("4eff15") #green
	elif base_health <= 60 and base_health >= 25:
		hp_bar.set_tint_progress("e1be32") #orange
	else:
		hp_bar.set_tint_progress("e11e1e") #red
