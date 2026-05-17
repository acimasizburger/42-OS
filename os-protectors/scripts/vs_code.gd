extends Control



# Kullanilacak dosyalarin adlarinin bulundugu yer
@onready var code_input = %CodeInput
@onready var terminal_label = $TerminalLabel
@onready var close_button = %CloseButton
@onready var referance_label = $ReferanceLabel

# Oyuncunun yazması gereken hedef kod
@export var kod_havuzu: Array[String] = []

var is_dragging = false
var drag_offset = Vector2()

func _ready():
	randomize()

# Inspector üzerinden istediğimiz kadar kod ekleyebiliriz
	var rastgele_indeks = randi() % kod_havuzu.size()
	referance_label.text = kod_havuzu[rastgele_indeks]

	close_button.hide() # Doğru kodu yazana kadar hide kalacak
	
	# giris yazisi
	terminal_label.text = "Terminal hazır. MeloCode'dan çıkmak için kodu hatasız derleyin."
	terminal_label.modulate = Color(1, 1, 1) # beyaza boya

func _on_close_button_pressed():
	queue_free()
	# code_input.text = ""
	# close_button.hide()
	# terminal_label.text = "Terminal hazır."
	# terminal_label.modulate = Color(1, 1, 1)

func _process(_delta):
	if is_dragging:
		# farenin anlik konumu - tikladigimiz konum
		global_position = get_global_mouse_position() - drag_offset

func _on_submitt_button_pressed() -> void:
	var yazilan_kod = code_input.text.strip_edges()
	var beklenen_kod = referance_label.text.strip_edges()
	
	if yazilan_kod == beklenen_kod:
		terminal_label.text = "Başarılı: Kod derlendi! Çıkış yapabilirsiniz."
		terminal_label.modulate = Color(0, 1, 0) 
		close_button.show()
	else:
		terminal_label.text = "Başarısız: Kodu birebir aynı yazamadınız. Lütfen tekrar deneyin."
		terminal_label.modulate = Color(1, 0, 0)


func _on_gui_input(event: InputEvent) -> void:
	# sol fare tusunu kontrol et
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			# nerden tikliyoz orayi aldigimiz kisim
			drag_offset = get_global_mouse_position() - global_position
		else:
			# birakirsan suruklemeyi birak
			is_dragging = false
