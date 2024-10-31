extends Pawn


func _input(event):
	if event.is_action_pressed("right_click"):
		var pawnGridPos = tileMap.WorldToMapPos(global_position)
		var clickGridPos = tileMap.WorldToMapPos(get_global_mouse_position())
		
		path = pathfinding.RequestPath(pawnGridPos, clickGridPos)
		
		DrawLine()
		

func _process(delta):
	EventBus.display_data.emit(str("State: ", state))
	EventBus.display_data.emit(str("Animation: ", animation_tree.get("parameters/playback").get_current_node()))
	EventBus.display_data.emit(str("Path Size: ", len(path)))
	EventBus.display_data.emit(str("Direction: ", animation_tree.get("parameters/Idle/blend_position")))
	
# if obj is load(res://script/resource) || get class, is class || groups || split item array by category 
	#if Input.is_action_just_pressed("ui_accept"):
		#var tileSize = terrain.tile_set.tile_size.x
		#var mapPos = position / tileSize
		#var closestItem = item_manager.FindNearestItem(Food, mapPos)
		#var closestItemPos = closestItem.position / tileSize 
		#path = pathfinding.findPath(mapPos, closestItemPos)
	#
		#DrawLine()
