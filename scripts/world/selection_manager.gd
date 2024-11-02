extends Control

# if something was selected/in area, open tray
# on release and empty: close tray, disable selection menu btn

#	selection manager emit signal if selection is empty or has something 
# NOTE we might not need this since buttons are updated in real time, just make
#	sure upon release, all items get deselected
#func OnSelectionFinished():
	# selection menu  has to react to this to clear list and actions
	#		or don't since menu willbe disabled anyway, so we care only about
	#		the selection start signal, only then we clear list and show 
	

## NOTE passing an typed array, such as Array[Item], Array[Pawn] and match the
##  array type seems more clean way of infering what type/cat we dealing with,
##  every time an obj that does not match the Array type
##	/category change, objs in the array get deselected and Array with new type 
##	is created to hold new selection, but we not passing arrays anymore

#signal SelectionStarted
signal FirstObjSelected
signal LastObjDeselected
signal AreaSelected(area: Area2D)
signal AreaDeselected(area: Area2D)
# NOTE selectiong category changed signal?

# NOTE make dict instead? plant = 0, so can get value directly, no converting
#	 back and forth between priority index and category name
var categoryPriority = ["Plant", "Animal", "Item", "Pawn"] 
var currPriority = 0

var overlapingAreas: Dictionary = {
	"Plant": [],
	"Animal": [],
	"Item": [],
	"Pawn": [],
}
var currSelection: Array[Area2D] = []

var tileSize: Vector2i

var canDrag: bool = true
# NOTE do we need this? if area entered/exited we must be dragging/selection rect enabled anyway
var isDragging: bool = false
var dragStartPos: Vector2

@onready var selection_rect: ReferenceRect = $SelectionRect
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


func _unhandled_input(event: InputEvent) -> void:
	if canDrag:
		if event.is_action_pressed("left_click"):
			StartDrag()		
		
	if isDragging:
		if event.is_action_released("left_click"):
			StopDrag()
			
		elif event is InputEventMouseMotion:
			UpdateDrag()
			

func _ready() -> void:
	area_2d.area_entered.connect(OnAreaEntered)
	area_2d.area_exited.connect(OnAreaExited)


func DecreasePriority():# SelectPreviousPriority, DecreasePriorityAndSelectCategory, FindAndSelectPreviousCategory
	var prevPriorities = range(currPriority - 1, -1, -1)
	print("prevPriorities: ", prevPriorities)
	
	for i in prevPriorities:
		currPriority = i
		print("priority decresed to ", currPriority)

		var category = categoryPriority[i]
		var isCategoryEmpty = overlapingAreas[category].is_empty()
		if not isCategoryEmpty:
			for a in overlapingAreas[category]:
				SelectArea(a)
				
			break			
		

func SelectArea(area: Area2D):
	area.Select()
	currSelection.append(area)
	print("area selected: ", area)
	AreaSelected.emit(area)
	
	
func DeselectArea(area: Area2D):
	area.Deselect()
	currSelection.erase(area)
	print("area deselected: ", area)
	AreaDeselected.emit(area)
	
	if currSelection.is_empty():
		DecreasePriority()
		
		
func ClearCurrSelection():
	print("clear before: ", currSelection)
	for a in currSelection:
		a.Deselect()
		AreaDeselected.emit(a)
		
	# NOTE use pop_front instead?
	currSelection.clear()
	print("clear after: ", currSelection)


func StartDrag():#StartSelection
	#ClearCurrSelection()
	#currPriority = 0
	dragStartPos = get_global_mouse_position()
	isDragging = true
	#area_2d.monitoring = true
	# NOTE why is this here?
	UpdateDrag()
	show()
	
	#SelectionStarted.emit()
	
	
func StopDrag():#StopSelection
	isDragging = false
	#area_2d.monitoring = false
	# NOTE why is this here?
	hide()
	

func UpdateDrag():# UpdateSelectionRect()
	# NOTE could use fmod/mod instead?
	# NOTE we only need to match the tile map grid when placing, not when selecting
	# 	well, the idea was to on click we select with an area of a single tile
	#	because there was no drag, but we don't have tile data and occupiers here
	#	so we better off with sprite selection for now
	#var gridStartPos: Vector2i = dragStartPos.floor() / tileSize.x
	#var gridEndPos: Vector2i = get_global_mouse_position().floor() / tileSize.x
	var dragCurrentPos = get_global_mouse_position() - dragStartPos
	var areaSize = abs(dragCurrentPos)
	selection_rect.custom_minimum_size = areaSize
	collision_shape_2d.shape.size = areaSize
	position = dragStartPos + dragCurrentPos / 2


# add objects to respective selection category
func AddEntry(area: Area2D):
	var object: Node2D = area.get_parent()
	var objCategory: StringName = object.get_script().get_global_name()
	var objPriority: int = categoryPriority.find(objCategory)
	
	overlapingAreas[objCategory].append(area)
	print("area entered:", area)
	
	if objPriority > currPriority:
		currPriority = objPriority
		print("priority increased to ", currPriority)
		ClearCurrSelection()
				
	
	if objPriority == currPriority:
		if currSelection.is_empty():
			# TODO we emiting this everytime priority increase
			# if priority = 0 and selection.is_empty() might be better
			# to check if entries are empty, still not ideal
			FirstObjSelected.emit()
			
		SelectArea(area)
	
	
# remove object from respective selection category
func RemoveEntry(area: Area2D):
	var object: Node2D = area.get_parent()
	var objCategory: StringName = object.get_script().get_global_name()
	
	overlapingAreas[objCategory].erase(area)
	print("area exited: ", area)
	# NOTE why is this here? so don't deselect upon release?
	#	if something enter doesn't that imply we dragging already?
	#	why else would we be registring areas?
	if isDragging:
		# NOTE letting areas get deselect on rect resize vs calling clearcurrselection
		# 	we don't know winch order objs exit, while not visible it might be 
		#	lowering priority and selecting previous priority 
		#	if it does it will show up on output
		if currSelection.has(area):			
			DeselectArea(area)


	
			
	
func OnMouseModeChanged(mouseMode: int):
	# if TileMap.MouseModes.SELECT
	if mouseMode == 0:
		canDrag = true
	else:
		canDrag = false


func OnAreaEntered(area: Area2D):
	AddEntry(area)	
	
	
func OnAreaExited(area: Area2D):
	RemoveEntry(area)	
			

func OnObjClicked(obj):
	pass
	# TODO clear current selection and select object
	
	
func OnObjDoubleClicked(obj):
	pass
	# TODO clear current selection and select visible objs of same type


func OnSelectionEntryRemoved(objects: Array):
	var areas = []
	for o in objects:
		areas.append(o.get_node("SelectionArea"))
	for a in areas:
		DeselectArea(a)
