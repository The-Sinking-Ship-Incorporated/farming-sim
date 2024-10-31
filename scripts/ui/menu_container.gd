extends Control

# RESPONSIBILITIES 
#	- swap menu container


@export_category("Tween Options")
@export_group("Menu Swap")
@export_range(0.1, 0.6, 0.1) var menuSwapDuration = 0.3
@export var menuSwapTrans = Tween.TRANS_CUBIC 
@export var menuSwapEase = Tween.EASE_IN_OUT


@onready var menu_container: HBoxContainer = $VBoxContainer/MenuContainer
@onready var v_box_container: VBoxContainer = $VBoxContainer

	
func _ready() -> void:
	owner.MenuButtonPressed.connect(OnMenuButtonPressed)
	#owner.CategoryButtonPressed.connect(OnCategoryButtonPressed)

	
func OnMenuButtonPressed(buttonIndex: int):
	# swap menu container
	var tween = create_tween().set_trans(menuSwapTrans).set_ease(menuSwapEase)
	var menuWidth = size.x
	var menuPos = Vector2(menuWidth * buttonIndex, 0)
	tween.tween_property(v_box_container, "position", -menuPos, menuSwapDuration)


#func OnCategoryButtonPressed(menuIndex: int, buttonIndex: int):
	## swap menu category
	#var targetMenu = menu_container.get_child(menuIndex).get_child(0)
	#var menuCategoryHeight = size.y
	#var targetPos = Vector2(0, menuCategoryHeight * buttonIndex)
	#var tween = create_tween().set_trans(categorySwapTrans).set_ease(categorySwapEase)
	#tween.tween_property(targetMenu, "position", -targetPos, categorySwapDuration)
	#
