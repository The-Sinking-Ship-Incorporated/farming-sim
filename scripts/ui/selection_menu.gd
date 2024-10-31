@icon("res://resource/atlas_texture/rpgicon.tres")
extends Control #TODO or Menu?


const LIST_ITEM_BUTTON = preload("res://scenes/ui/elements/selection_item_button.tscn")

# NOTE this and and @export task.tasktype enum could be in an action button script
#	have the action button init/generation code inside button script
#	like having textures map, so know what icon to use, would remove need for 
#	individual button resources, simply set task type and it handle the rest  
const TASK_BUTTON_MAP = {
	Task.TaskType.HARVEST: "res://scenes/ui/elements/action_buttons/action_button_harvest.tscn",
	Task.TaskType.DRAFT: "res://scenes/ui/elements/action_buttons/action_button_draft.tscn",
}

@export_category("Tween Options")
@export_group("Menu Category Swap")	
@export_range(0.1, 0.6, 0.1) var categorySwapDuration = 0.3
@export var categorySwapTrans = Tween.TRANS_CUBIC 
@export var categorySwapEase = Tween.EASE_IN_OUT

var itemEntries: = {}
var actionEntries: = {}

@onready var item_button_container: VBoxContainer = %ItemButtonContainer
@onready var item_information_container: VBoxContainer = %ItemInformationContainer
@onready var action_button_container: HBoxContainer = %ActionButtonContainer
@onready var menu_category_container: VBoxContainer = $VBoxContainer/MenuCategoryViewport/MenuCategoryContainer


func _ready() -> void:
	#owner.SelectionFinished.connect(OnSelectionFinished)
	owner.CategoryButtonPressed.connect(OnCategoryButtonPressed)
	

func CreateItemButton(entryName: String) -> Button:
	var button = LIST_ITEM_BUTTON.instantiate()	
	button.entryName = entryName
	button.LeftClicked.connect(OnButtonLeftClicked)
	button.DoubleLeftClicked.connect(OnButtonDoubleLeftClicked)
	button.RightClicked.connect(OnButtonRightClicked)
	item_button_container.add_child(button)
	
	return button
	

func UpdateItemButtonText(entryName: String):
	var itemEntry = itemEntries[entryName]
	var entryCategory = itemEntry["category"]
	var entryObjs = itemEntry["objects"]

	# in case entry is unique obj/dont need stacking default to entry name
	var buttonText = entryName
	
	match entryCategory:							
		"Item":# sum item count
			var itemCount = 0
			
			for o in entryObjs:
				itemCount += o.count
			
			buttonText = str(entryName, " x", itemCount)
				
		"Plant", "Animal":# count objects 
			buttonText = str(entryName, " x", entryObjs.size())
				
	var entryButton = itemEntry["button"]
	entryButton.text = buttonText
				

func CreateActionButton(taskType: Task.TaskType):		
	var button = load(TASK_BUTTON_MAP[taskType]).instantiate()
	button.pressed.connect(OnActionButtonPressed.bind(taskType))
	action_button_container.add_child(button)
	
	return button
		

func OnCategoryButtonPressed(menuIndex: int, buttonIndex: int):
	# swap menu category
	if get_parent().get_index() == menuIndex:
		var menuCategoryHeight = menu_category_container.size.y / menu_category_container.get_child_count()
		var targetPos = Vector2(0, menuCategoryHeight * buttonIndex)
		var tween = create_tween().set_trans(categorySwapTrans).set_ease(categorySwapEase)
		tween.tween_property(menu_category_container, "position", -targetPos, categorySwapDuration)


func OnAreaSelected(area: Area2D):
	var obj = area.get_parent()
	var objName = obj.objName
	var objCategory = obj.get_script().get_global_name()
	
	
	# update entry
	if itemEntries.has(objName):
		var itemEntry = itemEntries[objName]
		itemEntry["objects"].append(obj)
		UpdateItemButtonText(objName)
		
	# create entry
	else:		
		itemEntries[objName] = {
			"button" = CreateItemButton(objName),
			"objects" = [obj],
			"category" = objCategory,
		}
		
		UpdateItemButtonText(objName)
		
	
	# increment or create action button
	var objActions = obj.actions
	for a in objActions:
		if actionEntries.has(a):
			actionEntries[a]["refcount"] += 1 
		else:
			actionEntries[a] = {"button" = CreateActionButton(a), "refcount" = 1}
				
	print(itemEntries)
	
func OnAreaDeselected(area: Area2D):
	var obj = area.get_parent()
	var objName = obj.objName
	
	# decrement or remove item button
	var itemEntry = itemEntries[objName]
	var entryObjs = itemEntry["objects"]
	entryObjs.erase(obj)
	
	if entryObjs.is_empty():
		var itemButton = itemEntry["button"]
		itemButton.queue_free()
		itemEntries.erase(objName)
		
	else:
		UpdateItemButtonText(objName)

	# decrement or remove action button
	var objActions = obj.actions
	for a in objActions:
		actionEntries[a]["refcount"] -= 1 
		if actionEntries[a]["refcount"] == 0:
			var actionButton = actionEntries[a]["button"]	
			actionButton.queue_free()
			actionEntries.erase(a)

	print(itemEntries)
	
func OnButtonLeftClicked(entryName: String):
	pass	
	#TODO display data on obj info category 
	

func OnButtonDoubleLeftClicked(entryName: String):
	for e in itemEntries:
		if not e == entryName:
			var entryObjs = itemEntries[entryName]["objects"]
			owner.SelectionButtonRemoved.emit(entryObjs)
	
	
func OnButtonRightClicked(entryName: String):
	var entryObjs = itemEntries[entryName]["objects"]
	owner.SelectionButtonRemoved.emit(entryObjs)
	
	#TODO select button idx 0
	
	
func OnActionButtonPressed(taskType: Task.TaskType):
	owner.ActionButtonPressed.emit(taskType)



	
