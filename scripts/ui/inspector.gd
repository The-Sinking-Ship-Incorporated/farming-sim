extends TabContainer

var selectedPawn

@onready var hunger: ProgressBar = $Needs/VBoxContainer/Hunger/ProgressBar
@onready var sleep: ProgressBar = $Needs/VBoxContainer/Sleep/ProgressBar
@onready var recreation: ProgressBar = $Needs/VBoxContainer/Recreation/ProgressBar


func _ready() -> void:
	EventBus.pawn_clicked.connect(onPawnClicked)


func _process(delta: float) -> void:
	if selectedPawn:
		hunger.value = selectedPawn.get_node("PawnAI").foodNeed * 100
		sleep.value = selectedPawn.get_node("PawnAI").sleepNeed * 100
		recreation.value = selectedPawn.get_node("PawnAI").recreationNeed * 100
		

func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("right_click"):
		hide()

		
# get pawn data
func onPawnClicked(pawn):
	show()	
	selectedPawn = pawn


func onPawnDeselected():
	hide()
