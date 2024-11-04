extends CharacterBody2D
class_name Pawn

# RESPONSIBILITIES
# - move follow path
# - drawing sprite, path and selection
# - handle mouse clicks
 
signal Clicked

const SPEED = 50
const LINE2D = preload("res://scenes/world/line_2d.tscn")

@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

@onready var pathfinding = $"../Pathfinding"
@onready var tileMap = $"../TileMap"
@onready var item_manager: Node2D = $"../ItemManager"
@onready var selection_rect: ReferenceRect = $SelectionArea/SelectionRect
@onready var selection_sprite: Sprite2D = $Body
@onready var label: Label = $Anchor/Label

static var pawnCount = 0
static var maleNames = [
	"Tião",
	"Ciço",
	"Timbó",
	"Nego",
	"Uoshito",
	"Ventania",
	"Pezão",
	"Saçi",
	"Pajé",
	"Cambito",
	"Cacimba",
	"Barrote",
	"Ferruge",
	"Lampião",
	"Acerola",
	"Pipoca",
	"Goiaba",
	"Bagaço",
	"Paçoca",
	"Toicin",
	"Gororoba",
	"Rato",
	"Macaco",
	"Calango",
	"Lagatixa",
	"Muçego",
	"Muriçoca",
]
var objName: String
var actions: Array[Task.TaskType] = [Task.TaskType.DRAFT]
var path = []
var line_2d: Line2D
var state = "Idle"


func _ready() -> void:
	pawnCount += 1
	
	if maleNames:
		objName = maleNames.pop_front()
		label.text = objName
	else:
		objName = str("pawn ", pawnCount)
		label.text = objName
		
	selection_sprite.Clicked.connect(OnSpriteClicked)	


func _physics_process(delta):
	match state:
		"Idle":
			if path:
				state_machine.start("enter_walk", true)
				state = "Moving"
			
		"Moving":
			if not path:
				velocity = Vector2.ZERO
				state_machine.start("enter_idle", true)
				state = "Idle"
				return
			
			var direction = global_position.direction_to(path[0])
			var terrainDifficulty = tileMap.GetTerrainDifficulty(tileMap.WorldToMapPos(position))
			velocity = direction * SPEED * (1 / terrainDifficulty)
			
			animation_tree.set("parameters/Idle/blend_position", direction)
			animation_tree.set("parameters/Walk/blend_position", direction)
			animation_tree.set("parameters/Swing/blend_position", direction)
			
			if position.distance_to(path[0]) < SPEED * delta:
				path.remove_at(0)
				line_2d.remove_point(0)
			
			move_and_slide()
			
		"Harvesting":
			if path:
				state_machine.start("enter_walk", true)
				state = "Moving"


func SetMoveTarget(worldPos: Vector2):
	# same result as WorldToMap function
	var pos = tileMap.WorldToMapPos(position)
	var targetPos = tileMap.WorldToMapPos(worldPos)
	
	path = pathfinding.RequestPath(pos, targetPos)
	
	DrawLine()


func HasReachedDestination():
	return len(path) == 0
		
# draw path line
func DrawLine():
	if line_2d:
		line_2d.queue_free()
	
	line_2d = LINE2D.instantiate()
	line_2d.points = path
	get_parent().add_child(line_2d)


func OnSpriteClicked():
	Clicked.emit(self)
