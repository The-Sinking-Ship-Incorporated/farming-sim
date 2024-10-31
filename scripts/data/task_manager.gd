extends Node
class_name TaskManager

var taskQueue = []

	
func AddTask(taskType, targetItem):
	var newTask = Task.new()
	
	if taskType == Task.TaskType.HARVEST:
		newTask.InitHarvestPlantTask(targetItem)
		taskQueue.append(newTask)

# global work orders?
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


func OnActionButtonPressed(taskType: Task.TaskType):
	# TODO request task for every obj in selection
	pass
