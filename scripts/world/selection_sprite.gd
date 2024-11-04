extends Sprite2D


signal Clicked
signal DoubleClicked


func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		if is_pixel_opaque(get_local_mouse_position()):
			get_viewport().set_input_as_handled()
			Clicked.emit()
			
	elif event.is_action_pressed("left_click_double"):
		if is_pixel_opaque(get_local_mouse_position()):
			get_viewport().set_input_as_handled()
			DoubleClicked.emit()
