extends Button
class_name TileButton


#enum TileButtonGroups {ORDERS, STRUCTURE, TEMPERATURE, PRODUCTION, FURNITURE, SECURITY, POWER, DECORATION, MISC}
# could make room/wall box from area selection borders/perimeter
# tile/place mode for objects
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
# SHOULD WE HANDLE BUTTONS GLOBALLY?
# 	having buttons that can trigger funcs anywhere sounds like trouble, 
#	also having callable as variable that could be edited in the resource 
#		sounds bad
#@export var funcToCall : Callable = Callable(CommandHandler, "MyFunc")
#@export var funcToCall : Callable = Callable(self, setTile(TILE))
# load from folder or from preloader?

# we aint gona load a lot of buttons i think

#button container
	#match resource_name
	#load by prefix
	#
#OBJ, TRN, FLR, WAL
#BTN_OBJ_BOX, BTN_TRN_GRASS


#func callFuncInParent()
#	get_parent().call(func, arg)

# if all fail just use preloader to hold the button
#	and also match the preload consty


#You could create CallableResource class that extends Resource and stores
 #Callable inside and has a method call() which calls the Callable.
#
#i mean, if you want to make an item a resource but retain customized use()
 #functionality it might be convenient. especially if items might need to pop in
 #different use() functions like lego blocks to get different effects as items
 #are modified on larger scales.
