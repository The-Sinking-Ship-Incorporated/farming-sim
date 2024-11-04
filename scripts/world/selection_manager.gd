extends Control


#signal SelectionStarted
signal FirstObjSelected
signal LastObjDeselected
signal AreaSelected(area: Area2D)
signal AreaDeselected(area: Area2D)

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


func SelectPreviousCategory():#GetPreviousNonEmptyCategory
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
			
	if currSelection.is_empty():
		LastObjDeselected.emit()
	

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
		SelectPreviousCategory()
		
		
func ClearCurrSelection():
	print("clear before: ", currSelection)
	for a in currSelection:
		a.Deselect()
		AreaDeselected.emit(a)
		
	currSelection.clear()
	print("clear after: ", currSelection)


func StartDrag():#StartSelection
	#ClearCurrSelection()
	#currPriority = 0
	dragStartPos = get_global_mouse_position()
	isDragging = true
	#area_2d.monitoring = true
	
	UpdateDrag()
	show()
	
	#SelectionStarted.emit()
	
	
func StopDrag():#StopSelection
	isDragging = false
	#area_2d.monitoring = false
	hide()
	

func UpdateDrag():# UpdateSelectionRect()
	#var gridStartPos: Vector2i = dragStartPos.floor() / tileSize.x
	#var gridEndPos: Vector2i = get_global_mouse_position().floor() / tileSize.x
	var dragCurrentPos = get_global_mouse_position() - dragStartPos
	var areaSize = abs(dragCurrentPos)
	selection_rect.custom_minimum_size = areaSize
	collision_shape_2d.shape.size = areaSize
	position = dragStartPos + dragCurrentPos / 2


#func OnSelectionFinished():


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
			FirstObjSelected.emit()
			
		SelectArea(area)
	
	
# remove object from respective selection category
func RemoveEntry(area: Area2D):
	var object: Node2D = area.get_parent()
	var objCategory: StringName = object.get_script().get_global_name()
	
	overlapingAreas[objCategory].erase(area)
	print("area exited: ", area)
	 
	if isDragging:
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
	
	
func OnObjDoubleClicked(obj):
	pass


func OnSelectionEntryRemoved(objects: Array):
	var areas = []
	for o in objects:
		areas.append(o.get_node("SelectionArea"))
	for a in areas:
		DeselectArea(a)
