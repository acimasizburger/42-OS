extends Node

# --- 42 INTRA BİLGİLERİ ---
const CLIENT_ID = "u-s4t2ud-0e957f7568e5537a57e13dc132d66af4349d0d1ace99d88502f527e8ef6abd40"
const CLIENT_SECRET = "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"
const REDIRECT_URI = "http://localhost:8000" 

# Tarayıcıların CORS engellemesini aşmak için köprü (Proxy)
const CORS_PROXY = "https://corsproxy.io/?"

var token_req = HTTPRequest.new()
var me_req = HTTPRequest.new()

func _ready():
	# HTTP İstek düğümlerini koda otomatik ekliyoruz (Senin uğraşmana gerek kalmaz)
	add_child(token_req)
	add_child(me_req)
	token_req.request_completed.connect(_on_token_alindi)
	me_req.request_completed.connect(_on_me_alindi)

	# --- JAVASCRIPT KÖPRÜSÜ (URL'DEN KOD OKUMA) ---
	if OS.has_feature("web"):
		var url_search = JavaScriptBridge.eval("window.location.search;")
		if url_search and "code=" in str(url_search):
			# URL'den ?code=1234ABCD kısmını koparıp alıyoruz
			var code = str(url_search).split("code=")[1].split("&")[0]
			print("Intra Kodu Yakalandı: ", code)
			token_istegi_at(code)

# Butona basıldığında çağrılacak fonksiyon
func giris_yap_butonuna_basildi():
	var auth_url = "https://api.intra.42.fr/oauth/authorize?client_id=%s&redirect_uri=%s&response_type=code" % [CLIENT_ID, REDIRECT_URI]
	
	if OS.has_feature("web"):
		# Aynı sekmede 42 Intra girişine yönlendirir
		JavaScriptBridge.eval("window.location.href = '%s';" % auth_url)
	else:
		print("Bu özellik sadece Web Export alındığında çalışır!")

# ==========================================
# --- 42 API İSTEKLERİ ---
# ==========================================

func token_istegi_at(code: String):
	# CORS proxy üzerinden 42'ye Token (Bilet) soruyoruz
	var url = CORS_PROXY + "https://api.intra.42.fr/oauth/token"
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var body = "grant_type=authorization_code&client_id=%s&client_secret=%s&code=%s&redirect_uri=%s" % [CLIENT_ID, CLIENT_SECRET, code, REDIRECT_URI]
	
	token_req.request(url, headers, HTTPClient.METHOD_POST, body)

func _on_token_alindi(_result, response_code, _headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var access_token = json["access_token"]
		print("Token alındı! Profil bilgisi çekiliyor...")
		profil_bilgisini_cek(access_token)
	else:
		print("Token Hatası! Kod: ", response_code)

func profil_bilgisini_cek(token: String):
	# Aldığımız Token ile kullanıcının bilgilerini istiyoruz
	var url = CORS_PROXY + "https://api.intra.42.fr/v2/me"
	var headers = ["Authorization: Bearer " + token]
	me_req.request(url, headers, HTTPClient.METHOD_GET)

func _on_me_alindi(_result, response_code, _headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var intra_login = json["login"]
		
		print("GİRİŞ BAŞARILI! Hoş geldin: ", intra_login)
		
		# KULLANICI ADINI KAYDETME (Eğer Global bir scriptin varsa)
		# Global.intra_login = intra_login 
		
		# --- SAHNEYİ DEĞİŞTİRME YERİ BURASIDIR! ---
		# Doğrulama tamamen bitti, artık oyuncuyu ana oyuna alabiliriz.
		get_tree().change_scene_to_file("res://scenes/main.tscn") 
		
	else:
		print("Profil verisi alınamadı. Giriş başarısız!")
