extends Node

# WARNING pathfinding need terrain data to work with, must be after TileMap in
#	tree order, or mess up the ready order
#	is this as SMELL? relying on tree position
#	consider using init


@onready var tileMap = $"../TileMap"

var grid = AStarGrid2D.new()


func _ready():
	InitPathfinding()
	
# create and config the AStarGrid2d based on Terrain data
func InitPathfinding():
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.region = Rect2(Vector2.ZERO, Vector2(tileMap.mapWidth, tileMap.mapHeight))
	grid.cell_size = tileMap.tileSize
	grid.update()
	
	for x in tileMap.mapWidth:
		for y in tileMap.mapHeight:
			var gridCoord = Vector2i(x, y)
			var tileDifficulty = tileMap.GetTerrainDifficulty(gridCoord)
			if tileDifficulty == -1:
				grid.set_point_solid(gridCoord)
			else:
				grid.set_point_weight_scale(gridCoord, tileDifficulty)
			

func RequestPath(startMapPos : Vector2i, endMapPos : Vector2i):
	var path = grid.get_point_path(startMapPos, endMapPos)
	
	# offset path so walks through center of tile and not origin
	for i in len(path):
		# NOTE divided by float 2.0 rather than int 2, so we get 0.5 and not 0
		path[i] += tileMap.tileSize / 2.0
	
	return path
