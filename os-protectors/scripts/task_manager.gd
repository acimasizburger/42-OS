extends Node

signal görev_degisti(yeni_görev_metni)

var gorev_havuzu = [
	{"id": "vscode_yazilim", "taslak_metin": "VSCode'a gir ve istenen C kodunu hatasız derle."},
	{"id": "brave_evo", "taslak_metin": "Brave tarayıcısını aç ve EVO slotu seç."},
	{"id": "virus_sil", "taslak_metin": "Dosya Yöneticisindeki çöpleri sil"}
]

var toplam_gorev_sayisi = 1
var su_anki_görev_id = ""
var su_anki_görev_metni = ""

func _ready():
	await get_tree().create_timer(0.1).timeout
	yeni_rastgele_görev_uret()

func yeni_rastgele_görev_uret():
	# Havuzdan rastgele bir görev seç
	var rastgele_taslak = gorev_havuzu.pick_random()
	
	# EĞER HAVUZDA 1'DEN FAZLA GÖREV ÇEŞİDİ VARSA (Sonsuz döngüye girmemek için güvenlik kontrolü)
	if gorev_havuzu.size() > 1:
		# Seçilen yeni görev, şu anki(eski) görevle aynı olduğu sürece...
		while rastgele_taslak["id"] == su_anki_görev_id:
			# ...yeniden rastgele bir görev seç!
			rastgele_taslak = gorev_havuzu.pick_random()
	
	# Artık yeni ve farklı olduğundan emin olduğumuz görevi atıyoruz
	su_anki_görev_id = rastgele_taslak["id"]
	su_anki_görev_metni = "Görev " + str(toplam_gorev_sayisi) + ": " + rastgele_taslak["taslak_metin"]
	
	emit_signal("görev_degisti", su_anki_görev_metni)

func gorevi_tamamla(görev_id: String):
	if görev_id == su_anki_görev_id:
		print("Başarılı: Görev ", toplam_gorev_sayisi, " tamamlandı.")
		toplam_gorev_sayisi += 1
		yeni_rastgele_görev_uret()
	else:
		print("Yanlış görev tamamlanmaya çalışıldı. Beklenen: ", su_anki_görev_id)

func su_anki_gorevi_al() -> String:
	return su_anki_görev_metni
