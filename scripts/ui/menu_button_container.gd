extends Control


#region Tween Exports
@export_category("Tween Options")
@export_group("Selection Swap")
@export_range(0.1, 0.6, 0.1) var selectionDuration = 0.3
@export var selectionTransType = Tween.TRANS_CUBIC 
@export var selectionEaseType = Tween.EASE_IN_OUT

@export_group("Selection Fade In")
@export_range(0.1, 0.6, 0.1) var selectionFadeInDuration = 0.3
@export var selectionFadeInTrans = Tween.TRANS_CUBIC 
@export var selectionFadeInEase = Tween.EASE_IN_OUT

@export_group("Selection Fade Out")
@export_range(0.1, 0.6, 0.1) var selectionFadeOutDuration = 0.3
@export var selectionFadeOutTrans = Tween.TRANS_CUBIC 
@export var selectionFadeOutEase = Tween.EASE_IN_OUT
#endregion

@onready var selection_panel: Panel = $Anchor/SelectionPanel
@onready var menu_button_container: HBoxContainer = $MenuButtonContainer
@onready var selection_menu_button: Button = $MenuButtonContainer/SelectionMenuButton


func _ready() -> void:
	for b in menu_button_container.get_children():
		b.pressed.connect(OnButtonPressed.bind(b))


func FadeIn():
	var tween = create_tween().set_trans(selectionFadeInTrans).set_ease(selectionFadeInEase)
	tween.tween_property(selection_panel, "modulate", Color.WHITE, selectionFadeOutDuration)


func FadeOut():
	var tween = create_tween().set_trans(selectionFadeOutTrans).set_ease(selectionFadeOutEase)
	tween.tween_property(selection_panel, "modulate", Color.TRANSPARENT, selectionFadeInDuration)
	
		
func OnButtonPressed(button: Button):
	# animate selection panel
	var tween = create_tween()
	tween.set_trans(selectionTransType).set_ease(selectionEaseType)
	tween.set_parallel(true)
	
	var buttonPos = button.position
	var buttonSize = button.size
	
	tween.tween_property(selection_panel, "position", buttonPos, selectionDuration)
	tween.tween_property(selection_panel, "size", buttonSize, selectionDuration)
	
	owner.MenuButtonPressed.emit(button.get_index())
	

func OnFirstObjSelected():
	selection_menu_button.disabled = false
	selection_menu_button.button_pressed = true
	OnButtonPressed(selection_menu_button)
		
		
func OnLastObjDeselected():
	selection_menu_button.disabled = true
