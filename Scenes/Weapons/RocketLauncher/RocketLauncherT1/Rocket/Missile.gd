extends Area2D

signal missile_hit_enemy

var max_speed = 400
var drag_factor = 10
var direction

var _target

var _current_velocity := Vector2.ZERO

func start(target):
	_current_velocity = Vector2.RIGHT.rotated(rotation) * max_speed
	_target = target

func _physics_process(delta):
	if(is_instance_valid(_target)):
		direction = global_position.direction_to(_target.global_position)
	else:
		queue_free()
	var desired_velocity = direction * max_speed
	var previous_velocity = _current_velocity
	var change = (desired_velocity - _current_velocity).normalized() * drag_factor
	
	_current_velocity += change
	
	global_position += _current_velocity * delta
	look_at(global_position)
	
	
func _on_Missile_body_entered(body):
	emit_signal("missile_hit_enemy")
	queue_free()
