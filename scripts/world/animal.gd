extends CharacterBody2D

const SPEED = 50
const LINE2D = preload("res://scenes/line_2d.tscn")

@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

@onready var pathfinding = $"../Pathfinding"
@onready var terrain = $"../Terrain"

var path = []
var line_2d : Line2D
var state = "Idle"

func _process(delta):
	if state == "Idle":
		var pawnGridPos = terrain.local_to_map(global_position)
		var targetGridPos = terrain.local_to_map(global_position + Vector2(randi_range(-100, 100), randi_range(-100, 100)))
		path = pathfinding.findPath(pawnGridPos, targetGridPos)
		
		if line_2d:
			line_2d.queue_free()
		line_2d = LINE2D.instantiate()
		line_2d.points = path
		get_parent().add_child(line_2d)
	

func _physics_process(delta):
	match state:
		"Idle":
			if len(path) > 0:
				state_machine.start("Walk", true)
				state = "Moving"
			
		"Moving":
			if len(path) == 0:
				velocity = Vector2.ZERO
				state_machine.start("Idle", true)
				state = "Idle"
				return
			
			var direction = global_position.direction_to(path[0])
			var terrainDifficulty = terrain.getTerrainDifficulty(terrain.local_to_map(position))
			velocity = direction * SPEED * (1 / terrainDifficulty)
			
			animation_tree.set("parameters/Idle/blend_position", direction)
			animation_tree.set("parameters/Walk/blend_position", direction)
			animation_tree.set("parameters/Swing/blend_position", direction)
			
			if position.distance_to(path[0]) < SPEED * delta:
				path.remove_at(0)
				line_2d.remove_point(0)
			
			move_and_slide()
			
		
