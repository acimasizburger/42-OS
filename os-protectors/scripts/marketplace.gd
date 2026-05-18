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

func _on_buy_blocker_button_pressed():
	# Arka plandaki main_oyun ve spawner dosyalarını buluyoruz
	var main_node = get_tree().get_first_node_in_group("main_oyun")
	var spawner_node = get_tree().get_first_node_in_group("spawner")
	
	if main_node and spawner_node:
		if main_node.skor_harca(150):
			
			# 1. Spawner'ı yavaşlat (Senin önceden eklediğin kod)
			spawner_node.yavaslatici_baslat()
			
			# 2. YENİ: Main sahnesindeki sol alt göstergeyi 10 saniyeliğine aç!
			main_node.buff_gostergesini_ac(10.0)
			
			# Marketi kapat
			queue_free()
		else:
			print("Bunu almak için yeterli skorun yok!")
			# Buraya istersen ufak bir Label ile "Yetersiz Skor" yazdırabilirsin.

func _on_buy_clear_button_pressed():
	# Sadece puanı keseceğimiz main_oyun'u bulmamız yeterli
	var main_node = get_tree().get_first_node_in_group("main_oyun")
	
	if main_node:
		# Skor kontrolü (Bu eşya 200 skor olsun)
		if main_node.skor_harca(50):
			
			# İŞTE SİHİRLİ KOD: "virusler" etiketine sahip NE KADAR SAHNE VARSA hepsini sil!
			get_tree().call_group("virusler", "queue_free")
			
			print("ANTİVİRÜS ÇALIŞTI: Tüm sistem temizlendi!")
			
			# Marketi kapat
			queue_free()
		else:
			print("Bunu almak için yeterli skorun yok!")
