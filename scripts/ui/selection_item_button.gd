extends Button

signal LeftClicked
signal DoubleLeftClicked
signal RightClicked

var entryName: String

func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		LeftClicked.emit(entryName)
	
	elif event.is_action_released("left_click_double"):
		DoubleLeftClicked.emit(entryName)
		
	elif event.is_action_released("right_click"):
		RightClicked.emit(entryName)
			
