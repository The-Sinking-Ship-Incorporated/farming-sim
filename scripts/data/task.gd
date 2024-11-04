extends Node
class_name Task


enum TaskType {BASE_TASK, FIND_ITEM, WALK_TO, PICKUP, EAT, MANIPULATE, HARVEST, HUNT, DRAFT}

var taskName: String
var taskType: TaskType = TaskType.BASE_TASK

var subTasks = []
var currentSubTask : int = 0

var targetItem
var targetItemType

# are we at end?
func IsFinished() -> bool:
	return currentSubTask == len(subTasks)
	
# go to end, last subtask.
func Finish():
	currentSubTask = len(subTasks)

func GetCurrentSubTask():
	return subTasks[currentSubTask]
	
# advance task step.
func OnFinishSubTask():
	currentSubTask += 1
	
# complete finding item subtask and set next subtask item to what was found
func OnFoundItem(item):
	OnFinishSubTask()
	GetCurrentSubTask().targetItem = item

# complete walking subtask and pass item foward to next subtask
func OnReachedDestination():
	OnFinishSubTask()
	# current subtask item = last subtask item 
	GetCurrentSubTask().targetItem = subTasks[currentSubTask - 1].targetItem
	
# when pawn is idle and hungry this task is generated, 
#	find closest food, 
#		ask item manager if food exist in map, 
#			if does
#				ask pathfinding the path to said food
#			if not abort.
#	as pawn moves check if has arrived at locations yet, if did, 
#	picks up the task's target item 
#	then consume said food item
func InitFindAndEatFoodTask():
	taskName = "Find and eat some food"
	
	var subTask = Task.new()
	subTask.taskType = TaskType.FIND_ITEM
	subTask.targetItemType = ItemManager.ItemCategory.FOOD
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.WALK_TO
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.PICKUP
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.EAT
	subTasks.append(subTask)


func InitHarvestPlantTask(target):
	var subTask = Task.new()
	subTask.taskType = TaskType.WALK_TO
	subTask.targetItem = target
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.HARVEST
	subTask.targetItem = target
	subTasks.append(subTask)
