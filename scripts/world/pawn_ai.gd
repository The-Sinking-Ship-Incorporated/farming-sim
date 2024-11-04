extends Node

@onready var taskManager = $"../../TaskManager"
@onready var itemManager = $"../../ItemManager"

@onready var charController = $".."


enum PawnAction {IDLE, DOING_SUB_TASK, DRAFTED}#BUSY rather than DOING_SUB_TASK?

var currentAction: PawnAction = PawnAction.IDLE

var currentTask: Task = null

# Need Level
var foodNeed: float = 0.6 #0 =min, 1=max
var sleepNeed: float = 1.0 
var recreationNeed: float = 1.0 

# Depletion rate
var foodNeedDepleteSpeed: float = 0.01
var sleepNeedDepleteSpeed: float = 0.01
var recreationNeedDepleteSpeed: float = 0.01

# Action speed
var eatSpeed: float = 0.5

# Inventory
var inHand

# Skills
var harvestSkill: float = 1


func _process(delta):
	# depleteNeeds()
	foodNeed -= foodNeedDepleteSpeed * delta
	
	# if/while task not finished, keep processing steps
	if currentTask:
		DoCurrentTask(delta)
	# else check if need something, if does, get related task
	# if not doing anything, find something to do
	else:
		if foodNeed < 0.5:
			currentTask = taskManager.RequestFindAndEatFoodTask()
		else:
			currentTask = taskManager.RequestTask()

# get item ref and delete from world
func OnPickupItem(item):
	inHand = item
	itemManager.RemoveItemFromWorld(item)
		
# go idle and check if we done with task
# 	triggered after each task step/subtask conclusion 
func OnFinishedSubTask():
	currentAction = PawnAction.IDLE
	
	if currentTask.IsFinished():
		currentTask = null

# triggered while there is a task
func DoCurrentTask(delta):
	var subTask = currentTask.GetCurrentSubTask()
	# if idle start the current subtask
	if currentAction == PawnAction.IDLE:
		StartCurrentSubTask(subTask)
	else:
		match subTask.taskType:
			Task.TaskType.WALK_TO:
				# check if pawn arrived so can move on to next subtask
				if charController.HasReachedDestination():
					currentTask.OnReachedDestination()
					OnFinishedSubTask();
			
			Task.TaskType.EAT:
				# if item hasn't been consumed and pawn still hungry
				if inHand.nutrition > 0 and foodNeed < 1:
					# consume item and fill need
					inHand.nutrition -= eatSpeed * delta
					foodNeed += eatSpeed * delta
				# else free hand and finish subtask
				else:
					print("finished eating food")
					inHand = null
					 
					currentTask.OnFinishSubTask()
					OnFinishedSubTask()
					
			Task.TaskType.HARVEST:
				var targetItem = currentTask.GetCurrentSubTask().targetItem
				# call work function in object times delta
				if targetItem.TryHarvest(harvestSkill * delta):
					currentTask.OnFinishSubTask()
					OnFinishedSubTask()
				else:
					print(targetItem.harvestProgress)


# initialize subtask 
	# triggered if pawn has task but is idle (usually at start of task or between subtasks)
	# tasks start here and might continue on process loop
func StartCurrentSubTask(subTask):
	#print ("Starting subtask: " + Task.TaskType.keys()[subTask.taskType])
	
	match subTask.taskType:
		# find nearest item, if successful assign it to next subtask
		Task.TaskType.FIND_ITEM:
			var targetItem = itemManager.FindNearestItem(subTask.targetItemType, charController.position)
			# if found nothing can't do task, abort task
			if not targetItem:
				#print("no item, force task to finish")
				# goes to end/last subtask of current task
				currentTask.Finish()
			# else move to next subtask and assign found item to it
			else:
				print("target item pos: ", targetItem.position)
				currentTask.OnFoundItem(targetItem)
			# finding item or not, move to next subtask, 
			# 	if found nothing, task is erased since been set to last subtask	
			OnFinishedSubTask()
		# sets walking target, only completes when pawn reach target
		Task.TaskType.WALK_TO:
			charController.SetMoveTarget(subTask.targetItem.position)
			currentAction = PawnAction.DOING_SUB_TASK
		# pick the item and move to next subtask
		Task.TaskType.PICKUP:
			OnPickupItem(subTask.targetItem)
			currentTask.OnFinishSubTask()
			OnFinishedSubTask()
		# set to action to busy, only completes when there no nutrition left 
		Task.TaskType.EAT:
			currentAction = PawnAction.DOING_SUB_TASK
			
		# set to action to busy, only completes when 
		Task.TaskType.HARVEST:
			currentAction = PawnAction.DOING_SUB_TASK
