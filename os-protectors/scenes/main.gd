extends Node # (Godot varsayılan olarak Node2D veya Control verdiyse en üst satırı ona göre bırakabilirsin)

@onready var gorev_label = $TaskGiver/GorevLabel

func _ready():
	# Global TaskManager'dan gelen görev değişim sinyalini buraya bağlıyoruz
	TaskManager.görev_degisti.connect(_on_görev_degisti)
	
	# Oyun ilk açıldığında o anki görevi ekrana yazdırıyoruz
	gorev_label.text = TaskManager.su_anki_gorevi_al()

func _on_görev_degisti(yeni_metin: String):
	# Görev değiştikçe ekrandaki yazı otomatik olarak güncellenecek
	gorev_label.text = yeni_metin
