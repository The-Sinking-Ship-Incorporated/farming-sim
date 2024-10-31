extends Item
class_name Food

enum FoodType {OMNIVORE = 0, VEGETARIAN = 1, CARNIVORE = 2}
enum FoodQuality {RUBBISH = 0, SIMPLE = 1, GOOD = 2, FANCY = 3}

@export var nutrition = 1.0
@export var foodType : FoodType
@export var foodQuality : FoodQuality


func _init() -> void:
	super._init()
	add_to_group("Food")


func _ready() -> void:
	super._ready()
