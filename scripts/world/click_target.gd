extends Area2D

 
func _input_event(viewport, event, shape_idx):
	if event.is_action_released("left_click"):
		print(get_parent(), " clicked")
		get_parent().OnClick()
