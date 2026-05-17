extends Control

# Kullanilacak dosyalarin adlarinin bulundugu yer
@onready var code_input = %CodeInput
@onready var terminal_label = $TerminalLabel
@onready var close_button = %CloseButton
@onready var referance_label = $ReferanceLabel

# Oyuncunun yazması gereken hedef kod
var hedef_kod = "printf()"

var is_dragging = false
var drag_offset = Vector2()

func _ready():
	# Cikis butonunu gormek icin istenen kodu yazmamiz lazim
	close_button.hide()
	
	# Istenen fonksiyon adini yaziyoruz ki yazacak olan gorup yazsin
	referance_label.text = hedef_kod
	
	# giris yazisi
	terminal_label.text = "Terminal hazır. MeloCode'dan çıkmak için kodu hatasız derleyin."
	terminal_label.modulate = Color(1, 1, 1) # beyaza boya

func _on_close_button_pressed():
	hide()
	code_input.text = ""
	close_button.hide()
	terminal_label.text = "Terminal hazır."
	terminal_label.modulate = Color(1, 1, 1)


func _on_vs_code_button_pressed() -> void:
	show() #aciyo iste ne bekliyon amminakeee


func _process(_delta):
	if is_dragging:
		# farenin anlik konumu - tikladigimiz konum
		global_position = get_global_mouse_position() - drag_offset

func _on_submitt_button_pressed() -> void:
	var yazilan_kod = code_input.text.strip_edges()
	var beklenen_kod = hedef_kod.strip_edges()
	
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
