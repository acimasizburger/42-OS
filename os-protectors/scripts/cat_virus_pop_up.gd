extends Panel

# --- YENİ EKLENEN KISIM: Dışarıdan Ayarlanabilir (Export) Değişkenler ---
@export var virus_adi: String = "BedavaEvoPuani.exe"
@export var virus_resmi: Texture2D
@export var yonlendirilecek_url: String = "https://www.youtube.com/watch?v=goFEF4mio8Q" # Eski sabit linkin artık burada!

# Sürükleme işlemi için gerekli değişkenler (AYNI)
var is_dragging = false
var drag_offset = Vector2()

func _ready() -> void:
	# Oyun başladığında Inspector'daki resmi ve yazıyı ekrana yansıtıyoruz
	$VirusTitle.text = virus_adi
	if virus_resmi != null:
		$VirusImage.texture = virus_resmi

# --- 3. KAPATMA BUTONU (AYNI) ---
func _on_quit_button_pressed():
	queue_free() 

# --- 4. FOTOĞRAFA TIKLAMA (Sadece fonksiyonun adı genelleşti ve link değişkene bağlandı) ---
func _on_virus_image_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		OS.shell_open(yonlendirilecek_url) # Sabit link yerine yukarıdaki değişkeni çağırıyor

# --- 1. SÜRÜKLEME İŞLEMİ (BİREBİR AYNI) ---
func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset

# --- 2. ÜST BARA TIKLAMA (BİREBİR AYNI) ---
func _on_virus_up_bar_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false
