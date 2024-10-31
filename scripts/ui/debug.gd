extends Label

func _ready():
	EventBus.display_data.connect(add_to_label)

func _process(delta):
	text = ""

func add_to_label(data):
	text += str(data, "\n")
