extends PathFollow2D

func _physics_process(delta):
	set_offset(get_offset() + 45 * delta)
