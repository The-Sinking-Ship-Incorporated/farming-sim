extends Area2D


# NOTE getting clicked_tile.content/occupier from grid_data_map might be better,
#	so we are free to scale sprites	or at least make base item be the clickable
#	area, as all items would be clickable and have sprites being a child, 
#	so can be moved around without messing with click area
# SMELL one area for each item in the map will be exponentially expensive,
#	should instead get tile data and create selections and progress bars only 
#	when needed, and no clickable areas 2d
func _input_event(viewport, event, shape_idx):
	if event.is_action_released("left_click"):
		print(get_parent(), " clicked")
		get_parent().OnClick()
