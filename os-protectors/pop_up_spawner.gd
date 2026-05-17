extends Control

# Hazırladığımız pop-up sahnesini koda tanıtıyoruz
const POPUP_SCENE = preload("res://scenes/cat_virus_pop_up.tscn")

# Ekran çözünürlük sınırları (Pixel art projenize göre 320x180)
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

# Pop-up'ın ekran dışına tamamen taşmaması için kenar boşluğu güvenliği
# Pop-up boyutunuz yaklaşık neyse ona göre ayarlayın
const MARGIN_X = 80
const MARGIN_Y = 50

@onready var spawn_timer = $Timer

func _ready():
	# Timer süresi her bittiğinde tetiklenecek fonksiyonu bağlıyoruz
	spawn_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_popup()

func spawn_popup():
	# Pop-up sahnesinden bir kopya oluşturuyoruz
	var new_popup = POPUP_SCENE.instantiate()
	# Rastgele bir ekran koordinatı hesaplıyoruz (X: 0-320, Y: 0-180 arası)
	# Kenarlardan taşmaması için MARGIN değerlerini düşüyoruz
	var random_x = randf_range(0, SCREEN_WIDTH - MARGIN_X)
	var random_y = randf_range(0, SCREEN_HEIGHT - MARGIN_Y)
	
	# Pozisyonu atıyoruz
	new_popup.position = Vector2(random_x, random_y)
	
	# Her pop-up çıktığında bir sonraki pop-up daha hızlı gelir (en az 0.4 saniyeye düşer)
	spawn_timer.wait_time = max(0.4, spawn_timer.wait_time - 0.05)
	# Pop-up'ı spawner'ın altına (ekrana) ekliyoruz
	add_child(new_popup)
