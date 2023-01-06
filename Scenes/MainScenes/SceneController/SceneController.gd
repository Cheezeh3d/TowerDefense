extends Node

func _ready():
	load_main_menu()

##load all buttons and connect signals
func load_main_menu():
	get_node("MainMenu/MenuContainer/VBoxContainer/NewGame").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/MenuContainer/VBoxContainer/Continue").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/MenuContainer/VBoxContainer/Settings").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/MenuContainer/VBoxContainer/Quit").connect("pressed", self, "on_new_game_pressed")
	
##for when we press new_game button
func on_new_game_pressed():
	##free main menu
	get_node("MainMenu").queue_free()
	##load game scene
	var game_scene = load("res://Scenes/MainScenes/GameControllerScene/GameControllerScene.tscn").instance()
	##connect game_finished signal to unload game function
	game_scene.connect("game_finished", self, "unload_game")
	##add it to tree
	add_child(game_scene)
	
##for when we press continue button
func on_continue_pressed():
	pass
	
##for when we press settings button
func on_settings_pressed():
	pass
	
##for when we press quit
func on_quit_pressed():
	##use quit function on tree
	get_tree().quit()
	
##used to transition from game to main menui
func unload_game(result):
	##get game scene controller and free it
	get_node("GameControllerScene").queue_free()
	##get main menu
	var main_menu = load("res://Scenes/MainScenes/MainMenu/MainMenu.tscn").instance()
	##add main menu
	add_child(main_menu)
	##load main menu
	load_main_menu()
