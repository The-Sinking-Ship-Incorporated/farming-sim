extends Node

# RESPONSIBILITIES
# - connection between different components

@onready var tileMap = $World/TileMap
@onready var selectionManager = $WorldUI/SelectionManager
@onready var taskManager = $World/TaskManager

@onready var menuBar = $CanvasUI/MenuBar
@onready var selectionMenu = menuBar.get_node("%SelectionMenu")


func _ready() -> void:
	ConnectSignals()
	selectionManager.tileSize = tileMap.tileSize
	

func ConnectSignals():
	selectionManager.FirstObjSelected.connect(menuBar.OnFirstObjSelected)
	selectionManager.LastObjDeselected.connect(menuBar.OnLastObjDeselected)
	
	selectionManager.AreaSelected.connect(selectionMenu.OnAreaSelected)
	selectionManager.AreaDeselected.connect(selectionMenu.OnAreaDeselected)
	
	menuBar.SelectionEntryRemoved.connect(selectionManager.OnSelectionEntryRemoved)
	menuBar.ActionButtonPressed.connect(taskManager.OnActionButtonPressed)
