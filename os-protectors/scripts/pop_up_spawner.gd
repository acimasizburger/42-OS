extends Control

const VSCODE = preload("res://scenes/vs_code.tscn")

# DİKKAT: Artık tek bir "POPUP_SCENE" yok. Onun yerine dışarıdan 
# birden fazla sahne ekleyebileceğimiz bir liste (Array) var!
@export var virus_sahneleri: Array[PackedScene]

# Ekran dışında oluşturmasın diye
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

@onready var spawn_timer = $Timer

func _ready():
	spawn_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_popup()

func spawn_popup():
	# Eğer listeye hiç virüs eklemediysek oyun çökmesin diye güvenlik kontrolü
	if virus_sahneleri.is_empty():
		print("Hata: Inspector'dan virüs sahnelerini eklemeyi unuttun!")
		return
		
	# Listeden rastgele bir virüs sahnesi seç (Kedi, köpek, hacker vs.)
	var rastgele_sahne = virus_sahneleri.pick_random()
	
	# Seçilen rastgele sahneyi oluştur
	var new_popup = rastgele_sahne.instantiate()
	
	# Senin eklediğin dinamik boyut hesabı
	var popup_size = new_popup.size
	
	# Rastgele ekran koordinatı alıp pencere boyutunu aşmadan yerleştirmek için
	var random_x = randf_range(0, SCREEN_WIDTH - popup_size.x)
	var random_y = randf_range(0, SCREEN_HEIGHT - popup_size.y)
	
	new_popup.position = Vector2(random_x, random_y)
	
	# Yeni gelecek pop up için süreyi belirler. Minimum süre ve azalacak süre
	spawn_timer.wait_time = max(0.4, spawn_timer.wait_time - 0.03)
	add_child(new_popup)

func _on_vscode_pressed() -> void:
	var new_vscode = VSCODE.instantiate()

	add_child(new_vscode)
	var vscode_size = new_vscode.size
	
	var random_x = randf_range(0, SCREEN_WIDTH - vscode_size.x)
	var random_y = randf_range(0, SCREEN_HEIGHT - vscode_size.y)
	new_vscode.position = Vector2(random_x, random_y)

	if new_vscode.has_method("paneli_kur"):
		new_vscode.paneli_kur()
