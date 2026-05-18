extends Node

@onready var gorev_label = $TaskGiver/GorevLabel
@onready var timer_label = $TimerLabel
@onready var game_over_label = $GameOverLabel
@onready var score_label = $ScoreLabel # YENİ EKLENEN SKOR YAZISI
@onready var buff_ui = $BuffUI
@onready var buff_label = $BuffUI/buff_label # (Eğer ismini farklı yaptıysan burayı düzelt)
@onready var restart_button = $RestartButton
# Zamanlayıcı Değişkenleri
var kalan_sure: float = 60.0
var oyun_bitti: bool = false
var buff_kalan_sure: float = 0.0
var buff_aktif: bool = false

# Skor Değişkenleri
var toplam_skor: int = 0
var gorev_baslangic_zamani: int = 0 # Görevin başladığı anki gerçek zaman

func _ready():
	add_to_group("main_oyun") # Marketin bizi bulması için gruba ekledik
	game_over_label.hide()
	TaskManager.görev_degisti.connect(_on_görev_degisti)
	gorev_label.text = TaskManager.su_anki_gorevi_al()
	sure_arayuzunu_guncelle()
	restart_button.hide()
	
	# Oyun başlar başlamaz ilk görevin kronometresini başlat
	gorev_baslangic_zamani = Time.get_ticks_msec()
	score_label.text = "SKOR\n   0"

func _process(delta):
	if oyun_bitti:
		return
		
	kalan_sure -= delta
	
	if kalan_sure <= 0:
		kalan_sure = 0
		oyun_over()
	
	# YENİ: Ekranda buff süresini geriye saydırma
	if buff_aktif:
		buff_kalan_sure -= delta
		if buff_kalan_sure > 0:
			# Süreyi yukarı yuvarlayıp saniye (s) harfiyle ekrana yazıyoruz
			buff_label.text = str(ceil(buff_kalan_sure)) + "s"
		else:
			buff_aktif = false
			buff_ui.hide() # Süre bitince ikon ve yazıyı gizle
		
	sure_arayuzunu_guncelle()

func buff_gostergesini_ac(sure: float):
	buff_kalan_sure = sure
	buff_aktif = true
	buff_ui.show()

func sure_arayuzunu_guncelle():
	timer_label.text = str(ceil(kalan_sure))

# GÖREV BİTTİĞİNDE ÇALIŞAN FONKSİYON
func _on_görev_degisti(yeni_metin: String):
	gorev_label.text = yeni_metin
	
	if TaskManager.toplam_gorev_sayisi > 1:
		# --- 1. ZAMAN HESAPLAMASI ---
		var su_an = Time.get_ticks_msec()
		# Aradan geçen zamanı saniyeye çeviriyoruz (Örn: 3.5 saniye)
		var harcanan_saniye = (su_an - gorev_baslangic_zamani) / 1000.0 
		
		# --- 2. SKOR HESAPLAMASI ---
		# Eğer oyuncu 2 saniye veya altında yaparsa: 200 Puan
		# Eğer 10 saniye veya üzerinde yaparsa: 100 Puan
		# Arasındaysa, hıza göre orantılı bir puan alır.
		var kazanilan_puan = int(clamp(remap(harcanan_saniye, 2.0, 10.0, 200.0, 100.0), 100.0, 200.0))
		
		toplam_skor += kazanilan_puan
		score_label.text = "SKOR\n   " + str(toplam_skor)
		
		# Bir sonraki görev için kronometreyi anında sıfırla
		gorev_baslangic_zamani = su_an
		
		# --- 3. SÜRE ÖDÜLÜ VE EFEKTLER ---
		kalan_sure += 10
		
		# Skorun ve Sürenin aynı anda yeşil yanıp sönme efekti
		timer_label.modulate = Color(0, 1, 0)
		score_label.modulate = Color(0, 1, 0) 
		await get_tree().create_timer(0.2).timeout
		if not oyun_bitti:
			timer_label.modulate = Color(1, 1, 1)
			score_label.modulate = Color(1, 1, 1)

func skor_harca(miktar: int) -> bool:
	if toplam_skor >= miktar:
		toplam_skor -= miktar
		score_label.text = "SKOR\n   " + str(toplam_skor)
		return true
	else:
		# İstersen buraya skor yetersiz efekti/sesi ekleyebilirsin
		return false

func oyun_over():
	oyun_bitti = true
	timer_label.text = "SİSTEM ÇÖKTÜ"
	timer_label.modulate = Color(1, 0, 0)
	game_over_label.show()
	restart_button.show()
	restart_button.z_index = 100
	# İstersen oyun bitince final skorunu büyük yazının altına da yazdırabilirsin
	# game_over_label.text = "OYUN BİTTİ\nFİNAL SKOR: " + str(toplam_skor)
	
# YENİ FONKSİYON: Dışarıdan çağrıldığında süreden kesinti yapar
func zaman_cezasi_ver(ceza_miktari: float):
	kalan_sure -= ceza_miktari
	
	# Eğer süre 0'ın altına düşerse oyunu hemen bitir
	if kalan_sure <= 0:
		kalan_sure = 0
		oyun_over()
		
	sure_arayuzunu_guncelle()
	
	# HACKER DETAYI: Ceza yediğini belli etmek için yazıyı anlık kırmızı yap
	if not oyun_bitti:
		timer_label.modulate = Color(1, 0, 0) # Kırmızı
		await get_tree().create_timer(0.2).timeout
		timer_label.modulate = Color(1, 1, 1) # Beyaz (eski haline dön)


func _on_restart_button_pressed():
	get_tree().reload_current_scene()
