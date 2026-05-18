extends Control

const VSCODE = preload("res://scenes/vs_code.tscn")
const BRAVE = preload("res://scenes/brave_browser.tscn")
const EXPLORER = preload("res://scenes/file_explorer.tscn")
const MARKET = preload("res://scenes/marketplace.tscn")

@export var virus_sahneleri: Array[PackedScene]

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

@onready var spawn_timer = $Timer

# --- MARKET BUFF DEĞİŞKENLERİ ---
var is_buffed: bool = false
var kaydedilmis_sure: float = 4.0 # Orijinal zorluğu tutacağımız yer
var buff_timer: Timer

func _ready():
	add_to_group("spawner") # Marketin bizi bulması için gruba ekliyoruz
	spawn_timer.timeout.connect(_on_timer_timeout)
	
	# Marketten aldığımız 10 saniyelik buff için yeni bir sayaç oluşturuyoruz
	buff_timer = Timer.new()
	buff_timer.one_shot = true
	buff_timer.timeout.connect(_on_buff_bitti)
	add_child(buff_timer)

# ==========================================
# --- MARKET BUFF MANTIĞI ---
# ==========================================

func yavaslatici_baslat():
	# Eğer zaten buff devam ediyorsa eski zorluğu tekrar üzerine yazmasın diye kontrol ediyoruz
	if not is_buffed:
		kaydedilmis_sure = spawn_timer.wait_time # O anki zorluğu hafızaya al
		is_buffed = true
		
	# Süreyi %75 azaltmak demek, bekleme süresini 4 katına çıkarmak demektir
	spawn_timer.wait_time = kaydedilmis_sure * 4.0 
	spawn_timer.start() # Sayacı bu uzun süreyle yeniden başlat
	
	# 10 saniyelik geri sayımı başlat (ikinci kez alınırsa süreyi otomatik 10'a sıfırlar!)
	buff_timer.start(10.0) 
	print("GÜVENLİK DUVARI AKTİF! Pop-up'lar yavaşladı.")

func _on_buff_bitti():
	is_buffed = false
	# Buff bittiğinde hafızadaki asıl zorluk süresini geri yüklüyoruz
	spawn_timer.wait_time = kaydedilmis_sure 
	spawn_timer.start()
	print("Güvenlik duvarı süresi bitti. Sistem eski hızına döndü.")

# ==========================================
# --- POP UP SPAWN VE SAHNE ÇAĞIRMA ---
# ==========================================

func _on_timer_timeout():
	spawn_popup()

func spawn_popup():
	if virus_sahneleri.is_empty():
		print("Hata: Inspector'dan virüs sahnelerini eklemeyi unuttun!")
		return
		
	var rastgele_sahne = virus_sahneleri.pick_random()
	var new_popup = rastgele_sahne.instantiate()
	var popup_size = new_popup.size
	
	var random_x = randf_range(0, SCREEN_WIDTH - popup_size.x)
	var random_y = randf_range(0, SCREEN_HEIGHT - popup_size.y)
	
	new_popup.position = Vector2(random_x, random_y)
	
	# YENİ EKLENEN SATIR: Sadece virüslere bu etiketi yapıştırıyoruz
	new_popup.add_to_group("virusler")
	# KRİTİK DEĞİŞİKLİK: Oyun sadece buff AKTİF DEĞİLKEN zorlaşmaya devam etsin.
	# Yoksa buff varken matematiği bozar.
	if not is_buffed:
		spawn_timer.wait_time = max(0.4, spawn_timer.wait_time - 0.03)
		
	add_child(new_popup)

# --- UYGULAMA ÇAĞIRMA FONKSİYONLARI ---

func _on_vscode_pressed() -> void:
	var new_vscode = VSCODE.instantiate()
	add_child(new_vscode)
	var vscode_size = new_vscode.size
	var random_x = randf_range(0, SCREEN_WIDTH - vscode_size.x)
	var random_y = randf_range(0, SCREEN_HEIGHT - vscode_size.y)
	new_vscode.position = Vector2(random_x, random_y)

	if new_vscode.has_method("paneli_kur"):
		new_vscode.paneli_kur()

func _on_brave_pressed() -> void:
	var new_brave = BRAVE.instantiate()
	add_child(new_brave)
	var vscode_size = new_brave.size
	var random_x = randf_range(0, SCREEN_WIDTH - vscode_size.x)
	var random_y = randf_range(0, SCREEN_HEIGHT - vscode_size.y)
	new_brave.position = Vector2(random_x, random_y)

func _on_explorer_pressed() -> void:
	var new_exp = EXPLORER.instantiate()
	add_child(new_exp)
	var vscode_size = new_exp.size
	var random_x = randf_range(0, SCREEN_WIDTH - vscode_size.x)
	var random_y = randf_range(0, SCREEN_HEIGHT - vscode_size.y)
	new_exp.position = Vector2(random_x, random_y)

func _on_market_pressed() -> void:
	var new_market = MARKET.instantiate()
	add_child(new_market)
	var vscode_size = new_market.size
	var random_x = randf_range(0, SCREEN_WIDTH - vscode_size.x)
	var random_y = randf_range(0, SCREEN_HEIGHT - vscode_size.y)
	new_market.position = Vector2(random_x, random_y)
