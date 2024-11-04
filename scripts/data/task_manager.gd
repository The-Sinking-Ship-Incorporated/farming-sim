extends Node
class_name TaskManager

var taskQueue = []

@onready var selection_manager: Control = $"../../WorldUI/SelectionManager"

	
func AddTask(taskType, targetItem):
	var newTask = Task.new()
	
	if taskType == Task.TaskType.HARVEST:
		newTask.InitHarvestPlantTask(targetItem)
		taskQueue.append(newTask)


func RequestTask():
	if len(taskQueue) > 0:
		
		var task = taskQueue[0]
		taskQueue.erase(task)
		return task
		
	return null


# initialize and return a task depending on pawn current needs
func RequestFindAndEatFoodTask():
	var task = Task.new()
	task.InitFindAndEatFoodTask()
	return task


func RunActionOnSelectedObjs(taskType: Task.TaskType):
	var selectedObjs = []
	for a in selection_manager.currSelection:
		selectedObjs.append(a.get_parent())
	for o in selectedObjs:
		AddTask(taskType, o)


func OnActionButtonPressed(taskType: Task.TaskType):
	RunActionOnSelectedObjs(taskType)
		
		
