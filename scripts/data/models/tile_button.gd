extends Button
class_name TileButton


#enum TileButtonGroups {ORDERS, STRUCTURE, TEMPERATURE, PRODUCTION, FURNITURE, SECURITY, POWER, DECORATION, MISC}
enum SelectionType {TILE, LINE, AREA}
enum ArchitectCategory {
	MISC,
	ORDERS, 
	ZONES,
	SHELTER,
	STRUCTURE,
	PRODUCTION,
	FURNITURE,
	SECURITY,
	POWER,
	DECORATION, 
}

@export var tileData : Resource
@export var selection : SelectionType
@export var category : ArchitectCategory
#@export var tileData/metaData : TileData = Preloader.TRN_GRASS
