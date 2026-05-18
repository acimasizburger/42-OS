extends Control

@export var github_url: String = "https://github.com/acimasizburger/42-OS"

const Main = preload("res://scenes/main.tscn")

func _on_github_button_pressed() -> void:
	OS.shell_open(github_url)


func _on_start_pressed() -> void:
	# $OAuthManager.giris_yap_butonuna_basildi() Sadece 42 giriş sayfasını açar, tarayıcı o sayfaya gider.
	get_tree().change_scene_to_packed(Main) # Debug Test Icin
