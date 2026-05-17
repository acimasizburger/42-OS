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

func paneli_kur():
	
	if kod_havuzu.size() > 0:
		var rastgele_indeks = randi() % kod_havuzu.size()
		referance_label.text = kod_havuzu[rastgele_indeks]
	else:
		print("Liste şu an boş, işlem yapılamaz!")

	close_button.hide() 
	
	# giris yazisi
	terminal_label.text = "Terminal hazır. VSCode'dan çıkmak için kodu hatasız derleyin."
	terminal_label.modulate = Color(1, 1, 1)

func _on_close_button_pressed():
	queue_free()

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
		TaskManager.gorevi_tamamla("vscode_yazilim")
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
