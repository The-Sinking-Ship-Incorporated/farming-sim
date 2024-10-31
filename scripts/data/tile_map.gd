@tool
extends Node2D

# RESPONSIBILITIES
# - terrain generation
# - holds terrain difficulty/obstruction data

#region World Gen Exports
@export var generateTerrain = false

@export_range(128, 512, 128) var mapWidth: int = 128
@export_range(128, 512, 128) var mapHeight: int = 128
@export var tileSize = Vector2i(16, 16)

@export var terrainSeed: int = 0
@export var currentSeed: int = 0

@export_range(-1, 0) var iceThreshold: float = -0.3
@export_range(-1, 0) var stoneThreshold: float = -0.35
@export_range(-1, 0) var dirtThreshold: float = -0.4
@export_range(-1, 0) var forestThreshold: float = -0.54
@export_range(-1, 0) var grassThreshold: float = -0.58
@export_range(-1, 0) var sandThreshold: float = -0.6

@export_range(0, 1) var forestDensity: float = 0.67
#endregion

@onready var terrain: TileMapLayer = $Terrain
@onready var structures: TileMapLayer = $Structures
@onready var ghost_structures: TileMapLayer = $GhostStructures


func _process(delta):
	if generateTerrain:
		generateTerrain = false
		GenerateTerrain()

# NOTE don't need to be static since every item has access to item manager for some reason
func WorldToMapPos(worldPos: Vector2) -> Vector2i:
	# NOTE why there offset here? isn't pathfinding offseting result already?
	var offset = tileSize / 2
	# NOTE 	if a member of division is float result is float as well, when
	#	getting mapPos need integer precision, so we cast into Vector2i, this 
	#	is not needed when going MapToWorld as screen accepts half pixels
	#	could also have used .floor()
	return Vector2i(worldPos / tileSize.x)


# NOTE use TileMapLayer's map_to_local() instead? result already come with offset?
func MapToWorldPos(mapPos : Vector2i) -> Vector2:
	var offset = tileSize / 2

	return (mapPos * tileSize.x) + offset


func GenerateTerrain():
	terrain.clear()
	var rng = RandomNumberGenerator.new()
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR

	if terrainSeed == 0:
		var mapSeed = rng.randi()
		currentSeed = mapSeed
		noise.seed = mapSeed
		
	else:
		noise.seed = terrainSeed
		
	for x in mapWidth:
		for y in mapHeight:
			var noiseCoord = noise.get_noise_2d(x, y)
			
			if noiseCoord > iceThreshold:
				terrain.set_cell(Vector2i(x,y), 0, Vector2i(3, 0))
			elif noiseCoord > stoneThreshold:
				terrain.set_cell(Vector2i(x,y), 0, Vector2i(4, 0))
			elif noiseCoord > dirtThreshold:
				terrain.set_cell(Vector2i(x,y), 0, Vector2i(0, 1))
			elif noiseCoord > forestThreshold:
				var odd = randf_range(0.0, 1.0)
				if odd < forestDensity:
					terrain.set_cell(Vector2i(x,y), 0, Vector2i(1, 0))
				else:
					terrain.set_cell(Vector2i(x,y), 0, Vector2i(0, 0))
			elif noiseCoord > grassThreshold:
				terrain.set_cell(Vector2i(x,y), 0, Vector2i(0, 0))
			elif noiseCoord > sandThreshold:
				terrain.set_cell(Vector2i(x,y), 0, Vector2i(2, 0))
			else:
				terrain.set_cell(Vector2i(x,y), 0, Vector2i(4, 4))


func GetTerrainDifficulty(coords : Vector2i):
	#var layer = 0
	#var source_id = terrain.get_cell_source_id(coords)
	#var source = terrain.tile_set.get_source(source_id)
	#var atlas_coords = terrain.get_cell_atlas_coords(coords)
	var tile_data = terrain.get_cell_tile_data(coords)
	
	return tile_data.get_custom_data("walk_difficulty")
