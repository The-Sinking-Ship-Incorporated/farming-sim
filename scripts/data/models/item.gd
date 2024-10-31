extends Node2D
class_name Item

# SMELL item is too simple to warrant a scene, likely more expensive
#	we can do with simpler resource since only has texture, type/tag, amount
#	with scene also need to rename node inside scene as well to change name
#	current scene setup help with offseting mismaching assets

signal Clicked


@export var count: int
@export var weight: float
@export var category: ItemManager.ItemCategory


var objName: String
var actions: Array[Task.TaskType]

# SMELL item has awareness of outside things, so can request a task upon click
@onready var taskManager = $"../../TaskManager"
@onready var itemManager = $"../../ItemManager"
@onready var label: Label = $Anchor/Label


func _init() -> void:
	add_to_group("Item")
	

func _ready() -> void:
	objName = scene_file_path.get_file().trim_suffix(".tscn").replace("_", " ")
	label.text = str("x", count, " ", objName)
	
	$Sprite2D.Clicked.connect(OnSpriteClicked)


func OnSpriteClicked():
	Clicked.emit(self)
