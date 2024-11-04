extends Item
class_name Plant

var harvestProgress: float = 0
var harvestDifficulty: float = 4

# SMELL could we not use preloader constant here instead?
var harvestItem: String = "res://scenes/world/items/berries.tscn"
var harvestAmount: Vector2i = Vector2i(5, 15)

@onready var tile_map: Node2D = $"../../TileMap"


func _init():
	super._init()
	add_to_group("Plant")
	actions.append(Task.TaskType.HARVEST)
	

func _ready() -> void:
	super._ready()

# put work toward harvesting, check if is done and return result
func TryHarvest(amount: float) -> bool:
	harvestProgress += amount * 1/harvestDifficulty
	# if harvest is done delete and spawn what plant yields
	if harvestProgress >= 1:
		itemManager.RemoveItemFromWorld(self)
		var rng = RandomNumberGenerator.new()
		itemManager.SpawnItemByName(harvestItem, randi_range(harvestAmount.x, harvestAmount.y), tile_map.WorldToMapPos(position))
		return true
	else:
		return false
		
# NOTE selection action button should handle this		
func OnClick():
	taskManager.AddTask(Task.TaskType.HARVEST, self)
