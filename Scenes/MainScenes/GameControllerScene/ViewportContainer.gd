extends ViewportContainer

signal theInput(theEvent)

func _gui_input(event):
	if event.is_action_released("ui_cancel"):

		emit_signal("theInput", "ui_cancel")
	if event.is_action_released("ui_accept"):
		emit_signal("theInput", "ui_accept")

