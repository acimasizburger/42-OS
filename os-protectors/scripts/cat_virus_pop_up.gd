extends Panel

# Sürükleme işlemi için gerekli değişkenler
var is_dragging = false
var drag_offset = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# --- 3. KAPATMA BUTONU ---
func _on_quit_button_pressed():
	# Paneli sahneden tamamen siler. 
	# Eğer silinmesin sadece gizlensin istersen queue_free() yerine hide() yazabilirsin.
	queue_free() 


# --- 4. KEDİ FOTOĞRAFINA TIKLAMA ---
func _on_cat_photo_gui_input(event):
	# Sadece sol fare tuşu ile tıklandığında (pressed) çalışır
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Yönlendirmek istediğin siteyi buraya yaz
		OS.shell_open("https://profile-v3.intra.42.fr/users/alpturan")


# --- 1. SÜRÜKLEME İŞLEMİ (Her karede konumu günceller) ---
func _process(_delta):
	if is_dragging:
		# Farenin anlık konumundan, tıkladığımız noktanın farkını çıkararak paneli taşıyoruz
		global_position = get_global_mouse_position() - drag_offset

# --- 2. ÜST BARA TIKLAMA (Sürüklemeyi başlat/bitir) ---
func _on_virus_up_bar_gui_input(event):
	# Eğer sol fare tuşuna basılırsa
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			# Fareye tam olarak barın neresinden tıkladığımızı kaydediyoruz
			drag_offset = get_global_mouse_position() - global_position
		else:
			# Fare tuşu bırakıldığında sürüklemeyi durdur
			is_dragging = false
