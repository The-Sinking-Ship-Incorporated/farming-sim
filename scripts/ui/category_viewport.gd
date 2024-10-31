extends Control

# RESPONSIBILITIES
# - swap category container
# - animate selection panel

@export_category("Tween Options")
@export_group("Selection")
@export_range(0.1, 0.6, 0.1) var selectionDuration = 0.3
@export var selectionTransType = Tween.TRANS_CUBIC 
@export var selectionEaseType = Tween.EASE_IN_OUT

@export_group("Container")
@export_range(0.1, 0.6, 0.1) var swapDuration = 0.3
@export var swapTransType = Tween.TRANS_CUBIC 
@export var swapEaseType = Tween.EASE_IN_OUT

@onready var selection_panel: Panel = $SelectionPanel
@onready var category_button_containers: HBoxContainer = $CategoryButtonContainers


func _ready() -> void:
	owner.MenuButtonPressed.connect(OnMenuButtonPressed)

	# connect signal from buttons to OnButtonPressed func
	for c in category_button_containers.get_children():
		for b in c.get_children():
			b.pressed.connect(OnButtonPressed.bind(b))
			# press first button
			if b.get_index() == 0:
				OnButtonPressed(b)


func UpdateSelectionPanel(targetPos: Vector2):
	# animate selection panel position
	var tween = create_tween().set_trans(selectionTransType).set_ease(selectionEaseType)
	tween.tween_property(selection_panel, "position", targetPos, selectionDuration)


func OnButtonPressed(button: Button):
	# toggle disable mode for buttons in group
	for b in button.button_group.get_buttons():
		b.disabled = false
		
	button.disabled = true
	
	UpdateSelectionPanel(Vector2(0, button.position.y))
	
	var menuIndex = button.get_parent().get_index()
	owner.CategoryButtonPressed.emit(menuIndex, button.get_index())


func OnMenuButtonPressed(buttonIndex: int):
	# swap CategoryButtonContainers position
	var tween = create_tween().set_trans(swapTransType).set_ease(swapEaseType)
	var containerWidth = size.x
	var targetPos = Vector2(containerWidth * buttonIndex, 0)
	tween.tween_property(category_button_containers, "position", -targetPos, swapDuration)

	# get pressed button in this container to update selection panel
	var currCategoryContainer = category_button_containers.get_child(buttonIndex)
	for b in currCategoryContainer.get_children():
		if b.disabled:
			UpdateSelectionPanel(Vector2(0, b.position.y))
