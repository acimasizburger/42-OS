extends Node

@onready var click_player = $Mouse
@onready var key_player = $Keyboard

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		# Sürekli hızlı tıklamada sesin patlamasını/kesilmesini önlemek için:
		if click_player.is_playing():
			click_player.stop() # Mevcut çalma işlemini anında sıfırlar
		
		# Her tıklamada sesin tonunu hafifçe değiştirerek doğallık katıyoruz
		click_player.pitch_scale = randf_range(0.95, 1.05)
		click_player.play()

	elif event is InputEventKey and event.pressed and not event.is_echo():
		if key_player.is_playing():
			key_player.stop() # Çok hızlı yazarken seslerin üst üste binip çamurlaşmasını önler
			
		key_player.pitch_scale = randf_range(0.9, 1.1)
		key_player.play()
