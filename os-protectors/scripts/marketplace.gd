extends TextureRect

var is_dragging = false
var drag_offset = Vector2()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset

func _on_market_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false

func _on_close_button_pressed():
	queue_free()
