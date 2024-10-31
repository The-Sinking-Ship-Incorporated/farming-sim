extends Area2D


@onready var selection_rect: ReferenceRect = $SelectionRect


func Select():
	selection_rect.show()
	

func Deselect():
	selection_rect.hide()
