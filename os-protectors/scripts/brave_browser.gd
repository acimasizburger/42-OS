extends TextureRect # Eğer kök düğümün "Panel" ise burayı "extends Panel" yapmalısın.

# ==========================================
# --- DEĞİŞKENLER ---
# ==========================================

# Pencere sürükleme değişkenleri
var is_dragging = false
var drag_offset = Vector2()

# Evo mini oyun değişkenleri
var kacma_sayisi = 0
var max_kacma = 20

# Sahnedeki butonları koda tanımlıyoruz
@onready var evo_button = $EvoButton
@onready var evo_al_button = $EvoAlButton 

# ==========================================
# --- BAŞLANGIÇ AYARLARI ---
# ==========================================

func _ready():
	# Oyun başladığında nihai "Evo Al" butonunu gizliyoruz
	evo_al_button.hide()
	max_kacma = randi_range(10, 30)

# ==========================================
# --- SÜRÜKLEME VE PENCERE MEKANİKLERİ ---
# ==========================================

# Sürükleme aktifse pencereyi farenin konumuna göre hareket ettirir
func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset

# Görünmez üst bara (BraveUpBar) tıklandığında sürüklemeyi başlatır/bitirir
func _on_brave_up_bar_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false

# Sağ üstteki çarpıya basınca pencereyi kapatır (gizler)
func _on_close_button_pressed():
	queue_free()

# ==========================================
# --- EVO MİNİ OYUN MEKANİKLERİ ---
# ==========================================

# Fare, Evo butonunun üzerine geldiği an tetiklenir (Kaçma anı)
func _on_evo_button_mouse_entered():
	if kacma_sayisi < max_kacma:
		kacma_sayisi += 1
		
		# Farenin bu pencereye göre yerel pozisyonunu alıyoruz
		var farenin_konumu = get_local_mouse_position()
		
		# Güvenli pozisyon bulma değişkenleri
		var safe_pozisyon_bulundu = false
		var final_rastgele_konum = Vector2()
		
		# Güvenli bir yer bulana kadar bu döngü çalışacak
		# (Fizikte buna "recursive sampling" veya basitçe "reddetme örneklemesi" denir)
		while not safe_pozisyon_bulundu:
			# 1. Önce rastgele bir pozisyon aday seç
			final_rastgele_konum.x = randf_range(10, size.x - evo_button.size.x - 10)
			final_rastgele_konum.y = randf_range(40, size.y - evo_button.size.y - 10)
			
			# 2. Butonun o pozisyondaki alanını (kutusunu) hesapla (Rect2)
			var buton_alani = Rect2(final_rastgele_konum, evo_button.size)
			
			# Opsiyonel: Biraz daha insaflı davranmak için butonun etrafına
			# görünmez bir tampon bölge ekleyelim ki ucu bile fareye değmesin
			var tampon_bolge = 15 # piksel
			buton_alani = buton_alani.grow(tampon_bolge)
			
			# 3. KONTROL: Fare bu yeni rastgele alanın İÇİNDE Mİ?
			if not buton_alani.has_point(farenin_konumu):
				# Eğer fare dışındaysa, burası güvenli! Döngüyü kırabiliriz.
				safe_pozisyon_bulundu = true
			
			# Eğer has_point doğru (true) ise döngü başa döner ve yeni bir pozisyon arar.

		# Sonunda güvenli olduğundan emin olduğumuz koordinata ışınla
		evo_button.position = final_rastgele_konum
	else:
		# Yakalandıktan sonraki kod (AYNI KALDI)
		evo_button.modulate = Color(0, 1, 0)
		evo_al_button.show()

# En son çıkan "Evo Al" butonuna tıklandığında oyunu tamamlar
func _on_evo_al_button_pressed():
	# Global Görev Yöneticisi'ne Brave görevinin bittiğini haber ver
	TaskManager.gorevi_tamamla("brave_evo")
	
	# İşimiz bittiği için Brave penceresini kapat
	hide()
	
	# İleride görev tekrar gelirse diye Evo oyununu sıfırla
	kacma_sayisi = 0
	max_kacma = randi_range(10, 30)
	evo_al_button.hide()
	evo_button.modulate = Color(1, 1, 1) # Rengi normale (beyaza) döndür
