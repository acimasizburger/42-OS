extends TextureRect # (Veya kök düğümün neyse o)

# --- PENCERE DEĞİŞKENLERİ ---
var is_dragging = false
var drag_offset = Vector2()
@onready var status_label = $StatusLabel # BÜNU YENİ EKLEDİK

# --- SİSTEM DEĞİŞKENLERİ ---
@onready var item_list = $ItemList
@onready var trash_button = $TrashButton

# Oyuncunun oynadığı, değişebilen güncel liste
var guncel_dosyalar = {}
var acik_olan_klasor = ""

# Orijinal dosyalar (Ceza sisteminde her şeyi başa sarmak için "ana şablon")
var orijinal_dosyalar = {
	"Documents": [
		{"ad": "merhaba.txt", "virus_mu": false},
		{"ad": "fatura_detay.bat", "virus_mu": true}, # Virüs
		{"ad": "hello.txt", "virus_mu": false},
		{"ad": "melo.txt", "virus_mu": false}
	],
	"Music": [
		{"ad": "veryrealsong.rnp3", "virus_mu": true}, # Senin şüpheli dosyan
		{"ad": "klasik_muzik.mp3", "virus_mu": false},
		{"ad": "jenerik.wav", "virus_mu": false}
	],
	"Pictures": [
		{"ad": "tatil_fotografi.png", "virus_mu": false},
		{"ad": "sistem_hack.exe", "virus_mu": true} # Virüs
	],
	"Downloads": [
		{"ad": "leagueoflegends.dat", "virus_mu": true}, # Senin şüpheli dosyan
		{"ad": "godot.exe", "virus_mu": false},
		{"ad": "unrealengine.exe", "virus_mu": false}
	],
	"Home": [
		{"ad": "Test.file", "virus_mu": false},
		{"ad": "jenerik.wav", "virus_mu": false},
		{"ad": "importantfileDONTDELETE.dll", "virus_mu": true} # Senin şüpheli dosyan
	],
	"Starred": [
		{"ad": "memalli.usr", "virus_mu": false},
		{"ad": "memallisrs.usr2", "virus_mu": true}, # Senin şüpheli dosyan
		{"ad": "alpturan.usr", "virus_mu": false}
	],
	"Percent": [
		{"ad": "42OS.exe", "virus_mu": false},
		{"ad": "Aseprite.exe", "virus_mu": false},
		{"ad": "314qiakft.bat", "virus_mu": true} # Senin şüpheli dosyan
	],
}

# ==========================================
# --- BAŞLANGIÇ ---
# ==========================================

func _ready():
	status_label.text = "Sistem Taraması Bekleniyor..."
	sistemi_sifirla()

func sistemi_sifirla():
	# Orijinal listeyi kopyalayarak sistemi baştan kuruyoruz
	guncel_dosyalar = orijinal_dosyalar.duplicate(true)
	if acik_olan_klasor != "":
		klasoru_goster(acik_olan_klasor)
	
	# Görsel bir ceza geri bildirimi ekleyebilirsin
	item_list.modulate = Color(1, 0, 0) # Liste bir anlık kırmızı olur
	await get_tree().create_timer(0.3).timeout
	item_list.modulate = Color(1, 1, 1) # Normale döner

# ==========================================
# --- DOSYA LİSTELEME MANTIĞI ---
# ==========================================

# Herhangi bir klasöre tıklandığında içini ItemList'e çizer
func klasoru_goster(klasor_adi: String):
	acik_olan_klasor = klasor_adi
	item_list.clear() # Önceki listeyi temizle
	
	# Sözlükteki o klasöre ait dosyaları tek tek listeye ekle
	for dosya in guncel_dosyalar[klasor_adi]:
		item_list.add_item(dosya["ad"])

# Sol taraftaki butonların (Senin buton isimlerine göre ayarla)
func _on_documents_button_pressed():
	klasoru_goster("Documents")

func _on_music_button_pressed():
	klasoru_goster("Music")

func _on_pictures_button_pressed():
	klasoru_goster("Pictures")

func _on_downloads_button_pressed():
	klasoru_goster("Downloads")
	
func _on_home_button_pressed():
	klasoru_goster("Home")
	
func _on_starred_button_pressed():
	klasoru_goster("Starred")

func _on_percent_button_pressed():
	klasoru_goster("Percent")

# ==========================================
# --- SİLME VE CEZA MANTIĞI ---
# ==========================================

func _on_trash_button_pressed():
	var secili_indexler = item_list.get_selected_items()
	
	if secili_indexler.size() == 0:
		status_label.text = "Önce bir dosya seçmelisin!"
		status_label.modulate = Color(1, 1, 0) # Sarı renk
		return
		
	var secilen_index = secili_indexler[0]
	var secilen_dosya = guncel_dosyalar[acik_olan_klasor][secilen_index]
	
	if secilen_dosya["virus_mu"] == true:
		# BAŞARILI SİLİŞ!
		status_label.text = secilen_dosya["ad"] + " silindi!"
		status_label.modulate = Color(0, 1, 0) # Yeşil renk
		
		guncel_dosyalar[acik_olan_klasor].remove_at(secilen_index)
		klasoru_goster(acik_olan_klasor) 
		oyunu_kontrol_et()
	else:
		# YANLIŞ SİLİŞ!
		status_label.text = "Masum dosya silindi!"
		status_label.modulate = Color(1, 0, 0) # Kırmızı renk
		sistemi_sifirla()

func oyunu_kontrol_et():
	# Tüm klasörleri dolaşıp hayatta kalan virüs var mı diye bakıyoruz
	var virus_kaldi_mi = false
	for klasor in guncel_dosyalar.keys():
		for dosya in guncel_dosyalar[klasor]:
			if dosya["virus_mu"] == true:
				virus_kaldi_mi = true
				break
	
	if not virus_kaldi_mi:
		# VİRÜSLERİN HEPSİ TEMİZLENDİ!
		item_list.clear()
		item_list.add_item("SİSTEM TEMİZ!")
		status_label.text = "Sistem güvene alındı."
		status_label.modulate = Color(0, 1, 0)
		
		# --- GÖREV YÖNETİCİSİNİ TETİKLİYORUZ ---
		TaskManager.gorevi_tamamla("dosya_temizle")
		
		# Oyuncunun "Başarılı" mesajını okuyabilmesi için 1.5 saniye bekletip pencereyi siliyoruz
		await get_tree().create_timer(1.5).timeout
		queue_free()

# ==========================================
# --- SÜRÜKLEME VE PENCERE MANTIĞI (AYNI) ---
# ==========================================

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset

func _on_up_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false

func _on_close_button_pressed():
	queue_free()
