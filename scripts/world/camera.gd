extends Camera2D

const PAN_AMOUNT = 40
const PAN_SPEED = 5
const ZOOM_SPEED = 10

var canMove = true
var isMoving = false

var zoomSpeed = 0.5
var zoom_target = zoom

var last_drag_pos = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		ZoomIn()
		
	elif event.is_action_pressed("scroll_down"):
		ZoomOut()



#func _process(delta):
	#update_pan(delta)
	#update_drag()
	#
#
#
#func update_pan(delta):
	#
	#var dir = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
	#
	#pan_target += (dir * PAN_AMOUNT) / zoom.x
		#
	#position = lerp(position, pan_target, PAN_SPEED * delta) 


func MoveToMouse():
	isMoving = true
	
	var tween = create_tween().set_parallel()
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_method(Input.warp_mouse, get_viewport().get_mouse_position(), get_viewport_rect().size / 2 , 0.5)
	tween.tween_property(self, "position", get_global_mouse_position(), 0.5)
	tween.chain().tween_property(self, "isMoving", false, 0)


func ZoomIn():
	if not canMove:
		return
		
	zoom_target *= 1.4
		
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "zoom", zoom_target, zoomSpeed)
	
	if not isMoving:
		MoveToMouse()
	

func ZoomOut():
	if not canMove:
		return
	
	zoom_target *= 0.6
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "zoom", zoom_target, zoomSpeed)


#func update_drag():
	#if Input.is_action_just_pressed("middle_click"):
		#last_drag_pos = get_global_mouse_position()
		#
		#
	#if Input.is_action_pressed("middle_click"):
		#var current_drag_pos = get_global_mouse_position()
		#
		#pan_target += (last_drag_pos - current_drag_pos)
		#position += (last_drag_pos - current_drag_pos)
		#
		#
