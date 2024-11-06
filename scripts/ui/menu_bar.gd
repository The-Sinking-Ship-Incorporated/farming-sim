extends PanelContainer
class_name NavigationBar

# RESPONSIBILITIES (see documentating resources)
#	set control sizes dynamically 
#		1. set cat_viewport.min.x to button.min.x
#		2. set panel_container.min.x to menu_viewport.size.x * tab_buttons
#		or number of collums we wanna display in architect * tile_button.size.x + 4 (from grid_container separation)
#		this might be a better variable to regulate tab bar global width, rather than the other way around
#		3. set main_cat_container.min.y to biggest_cat_container.size.y * cat_containers
#		or number of rows we wanna display in architect * tile_button.size.y + 4 (from grid_container separation)
#
#	toggle visibility
#
#	connection between children
#		- cat-cont sig to option-cont func 
#		- menu-cont sig to option-cont func 

#region Signals
signal MenuButtonPressed(buttonIndex: int)
signal CategoryButtonPressed(menuIndex: int, buttonIndex: int)
signal ActionButtonPressed(taskType: Task.TaskType, objects: Array)

signal SelectionButtonSelected(worldObjects: Array)
signal SelectionEntryRemoved(worldObjects: Array)
#endregion

enum VisibilityModes {VISIBLE, COUNTDOWN, HIDDEN}
enum MouseModes {SELECT, PLACE}
enum PlacingModes {TILE, LINE, PERIMETER, AREA}

@export_range(1, 5, 0.5) var trayCloseTime = 1.0

#region Tween Options
@export_category("Tween Options")
@export_group("Menu Open")
@export_range(0.1, 0.6, 0.1) var menuOpenDuration = 0.3
@export var menuOpenTrans = Tween.TRANS_CUBIC 
@export var menuOpenEase = Tween.EASE_IN_OUT

@export_group("Menu Close")
@export_range(0.1, 0.6, 0.1) var menuCloseDuration = 0.3
@export var menuCloseTrans = Tween.TRANS_CUBIC 
@export var menuCloseEase = Tween.EASE_IN_OUT

@export_group("Menu Fade In")
@export_range(0.1, 0.6, 0.1) var menuFadeInDuration = 0.3
@export var menuFadeInTrans = Tween.TRANS_CUBIC 
@export var menuFadeInEase = Tween.EASE_IN_OUT

@export_group("Menu Fade Out")
@export_range(0.1, 0.6, 0.1) var menuFadeOutDuration = 0.3
@export var menuFadeOutTrans = Tween.TRANS_CUBIC 
@export var menuFadeOutEase = Tween.EASE_IN_OUT
#endregion

var visibilityMode: VisibilityModes = VisibilityModes.HIDDEN
var visibilityTimer = 0

var mouseMode: MouseModes = MouseModes.SELECT
var lastTileData# or button, use only this var instead?

@onready var category_viewport: Control = $HBoxContainer/Categories/CategoryViewport
@onready var menu_viewport: Panel = $HBoxContainer/VBoxContainer/MenuViewport

@onready var menu_buttons: HBoxContainer = $HBoxContainer/VBoxContainer/MenuButtons
@onready var selection_menu: MarginContainer = %SelectionMenu


func _ready() -> void:
	ConnectSignals()


func _process(delta: float) -> void:
	if visibilityMode == VisibilityModes.COUNTDOWN:
		if visibilityTimer < 0:
			CloseTray()
			FadeOut()
		else:
			visibilityTimer -= delta


func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("right_click"):
		CloseTray()
	

func ConnectSignals():
	mouse_entered.connect(OnMouseEntered)
	mouse_exited.connect(OnMouseExited)
	
	MenuButtonPressed.connect(OnMenuButtonPressed)
	
	
func FadeIn():
	var tween = create_tween().set_trans(menuFadeInTrans).set_ease(menuFadeInEase)
	tween.tween_property(self, "modulate", Color.WHITE, menuFadeInDuration)
	

func FadeOut():
	var tween = create_tween().set_trans(menuFadeOutTrans).set_ease(menuFadeOutEase)
	tween.tween_property(self, "modulate", Color.WHITE / 2, menuFadeOutDuration)
	

func OpenTray():
	var height = get_viewport_rect().size.y
	var targetPos = Vector2(position.x, height - size.y)
	
	var tween = create_tween().set_trans(menuOpenTrans).set_ease(menuOpenEase)
	tween.tween_property(self, "position", targetPos, menuOpenDuration)
	
	visibilityMode = VisibilityModes.VISIBLE
	
	FadeIn()
	menu_buttons.FadeIn()

	
func CloseTray():
	var height = get_viewport_rect().size.y
	var targetPos = Vector2(position.x, height - menu_buttons.size.y)

	var tween = create_tween().set_trans(menuCloseTrans).set_ease(menuCloseEase)
	tween.tween_property(self, "position", targetPos, menuCloseDuration)
		
	visibilityMode = VisibilityModes.HIDDEN
	
	FadeOut()
	menu_buttons.FadeOut()
	

func OnMouseEntered():
	print("entered")
	match mouseMode:
		MouseModes.PLACE:
			if visibilityMode == VisibilityModes.HIDDEN:
				OpenTray()
		MouseModes.SELECT:
			if visibilityMode == VisibilityModes.HIDDEN:
				FadeIn()
			elif visibilityMode == VisibilityModes.COUNTDOWN:
				visibilityMode = VisibilityModes.VISIBLE
					
	
func OnMouseExited():
	print("exited")
	match mouseMode:
		MouseModes.PLACE:
			CloseTray()
		MouseModes.SELECT:
			if visibilityMode == VisibilityModes.HIDDEN:
				FadeOut()

			elif visibilityMode == VisibilityModes.VISIBLE:
				visibilityTimer = trayCloseTime
				visibilityMode = VisibilityModes.COUNTDOWN	
	

func OnMenuButtonPressed(_buttonIndex: int):
	#if mouseMode == MouseModes.PLACE:
		#pass 
	OpenTray()	
	

func OnTileButtonPressed():
	CloseTray()


func OnFirstObjSelected():
	menu_buttons.OnFirstObjSelected()
	
	OpenTray()
		
		
func OnLastObjDeselected():
	menu_buttons.OnLastObjDeselected()
	
	CloseTray()
