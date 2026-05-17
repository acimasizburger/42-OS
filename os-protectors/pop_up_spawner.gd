extends Control

const VSCODE = preload("res://scenes/vs_code.tscn")
const POPUP_SCENE = preload("res://scenes/cat_virus_pop_up.tscn")

# Ekran dışında oluşturmasın diye
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

# Pop-up boyutu
const MARGIN_X = 90
const MARGIN_Y = 54

@onready var spawn_timer = $Timer

func _ready():
	spawn_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_popup()

func spawn_popup():
	var new_popup = POPUP_SCENE.instantiate()

	# Rastgele ekran koordinatı alıp pencere boyutunu aşmadan yerleştirmek için
	var random_x = randf_range(0, SCREEN_WIDTH - MARGIN_X)
	var random_y = randf_range(0, SCREEN_HEIGHT - MARGIN_Y)
	
	new_popup.position = Vector2(random_x, random_y)
	
	# Her pop-up çıktığında bir sonraki pop-up daha hızlı gelir 
	spawn_timer.wait_time = max(0.4, spawn_timer.wait_time - 0.03)
	add_child(new_popup)


func _on_vs_code_gui_input(event: InputEvent) -> void:
	var new_vscode = VSCODE.instantiate()
	
	var random_x = randf_range(0, SCREEN_WIDTH - MARGIN_X)
	var random_y = randf_range(0, SCREEN_HEIGHT - MARGIN_Y)
	
	new_vscode.position = Vector2(random_x, random_y)
	add_child(new_vscode)
