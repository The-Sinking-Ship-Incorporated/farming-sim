extends Control
class_name Menu

@export var menu_category_container: Control


func OnCategoryButtonPressed(buttonIndex: int):
	pass

# TODO cat buttons created from menu category
#	for every category in each menu we crete a button inside respective
#	cat button container, the menu category would have the icon for the category
#	we would also bind menu category reference to button press, so we know what
#	we want to display

# having each button in a control and only toggle it's visibility might be more
#	streamlined, sice we would use same code in all TabMenus, that would 
#	simplify things as we could ditch comparing by groups and TabMenu 
#	inheritance entirely, as sugested below, 
#	we can also inject the panel to 
#	show in the category button. but doing so would also remove the ability to
#	filter by name or tags in the future without a redundant item panel for that
#
# 	another alternative would be to make the category pressed a virtual method
#	to be overiden, so each TabMenu decide what to do upon category click, that
#	would be a more flexible approach, allowing a greate variety of reactions
#	
#	might also consider making an array of category and another for tile buttons
#	then we use this array data to instance each button rather than using enums,
#	this give way we can use resource editor, 
#	edit all entries centralized/in a single place 
