extends Node2D
class_name ItemManager

# RESPONSIBILITIES
# - load items resources from disk to memory
# - spawn/remove operations
const PAWN = preload("res://scenes/world/agents/pawn.tscn")

enum ItemCategory {ITEM = 0, FOOD = 1, WEAPON = 2, MELEEWEAPON = 3, PROJECTILEWEAPON = 4}
var itemCategories = ["Item", "Food", "Weapons", "MeleeWeapon", "ProjectileWeapon"]

#var foodPrototypes : Array[PackedScene] = []
var itemPrototypes : Array[PackedScene] = []

var itemsInWorld = []

@onready var tileMap: Node2D = $"../TileMap"


func _ready() -> void:
	#LoadFood()
	#SpawnItem(foodPrototypes[0], Vector2i(0, 0))
	#TODO - we wanted to avoid make folders and loading each item type to a 
	#	different array seemed pointless, but that allow to create button on
	#	respective categories rather than making the buttons manually, 
	#	then binding data to button, also manually? 
	#	must have object first for then have a button assotiated with it,
	#	not the other way around, makes more sense than having broke buttons
	#	smart code, dumb structure
	#	but how gonna handle sprites? the items have sprites no? 
	#	we can still do that by using node.is_in_group? for now at least
	#	bind loaded resource to respective button pressed signal
	LoadItemPrototypes()
	SpawnItemByName("res://scenes/world/items/berry_bush.tscn", 1, Vector2i(10,10))
	SpawnItemByName("res://scenes/world/items/berry_bush.tscn", 1, Vector2i(15,12))
	
	var newPawn = PAWN.instantiate()
	newPawn.position = Vector2(384, 384)
	get_parent().add_child.call_deferred(newPawn)


#func LoadFood():
	#var path = "res://scenes/world/items/"
	#var dir = DirAccess.open(path)
	#dir.list_dir_begin()
	#
	#while true:
		#var file_name = dir.get_next()
		#if file_name == "":
			#break
		#elif file_name.ends_with(".tscn"):
			#foodPrototypes.append(load(path + "/" + file_name))

# load resources to item template array
func LoadItemPrototypes():
	var allFileNames = Utils._dir_contents("res://scenes/world/items/", ".tscn")
	for fileName in allFileNames:
		itemPrototypes.append(load(fileName))
		print(fileName)


#func SpawnItem(item : PackedScene, mapPos : Vector2i):
	#var newItem = item.instantiate()
	#newItem.position = MapToWorldPosition(mapPos)
	#itemsInWorld.append(newItem)
	#add_child(newItem)
	
 
func SpawnItemByName(itemName : String, amount: int, mapPos : Vector2i):
	var newItem
	
	for item in itemPrototypes:
		if item.get_path() == itemName:
			newItem = item.instantiate()
			newItem.count = amount
			
	if newItem:
		add_child(newItem)
		itemsInWorld.append(newItem)
		newItem.position = tileMap.MapToWorldPos(mapPos)
		print("spawned ", newItem)


# remove world object and array reference
func RemoveItemFromWorld(item : Node2D):
	print("removed ", item.get_script().get_global_name())
	remove_child(item)
	itemsInWorld.erase(item)	


func FindNearestItem(itemCategory : ItemCategory, worldPosition : Vector2):
	var nearestItem = null
	var nearestDistance = INF
	
	for item in itemsInWorld:	
		if IsItemInCategory(item, itemCategory):
			var distance = worldPosition.distance_to(item.position)
			
			if not nearestItem:
				nearestItem = item
				nearestDistance = distance
				continue
				
			if distance < nearestDistance:
				nearestItem = item
				nearestDistance = distance
				
	return nearestItem


func IsItemInCategory(item, itemCategory) -> bool:
	return item.is_in_group(itemCategories[itemCategory])
