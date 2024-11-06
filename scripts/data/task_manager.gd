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


func CreateTaskForEachObj(taskType: Task.TaskType, objects: Array):# RunActionOnObjects
	for o in objects:
		AddTask(taskType, o)


func OnActionButtonPressed(taskType: Task.TaskType, objects: Array):
	CreateTaskForEachObj(taskType, objects)
		
		
