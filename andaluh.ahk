#Persistent
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

; berçion
berçion := 0.5.1

; Eliminâh tôh lô elementô de menú êççîttentê 
;Menu, Tray, Icon, andaluh.ico 
Menu, Tray, NoStandard
Menu, Tray, Add, Ayuda, ShowAyuda
Menu, Tray, Add, Recargar, ReloadScript
Menu, Tray, Add, Salir, ExitScript
; Definiçión de lâ funçionê que çe ehecutarán ar çelêççionâh cá elemento der menú 
ExitScript(){
	CloseScript("keyboardhook")
	ExitApp
	Return
}
ReloadScript(){
	CloseScript("keyboardhook")
	Run, "%A_ScriptFullPath%"
Return
}
ShowAyuda(){
	têhto := "`n`nAndalûh Berçion: 0.5.1 `nKeyboardhook Berçion: 0.3 `nFilehandler Berçion: 0.2 `n`nCTRL+ALT+P = Âttibâh / pauçâh er trâccrîttôh automatico `n`nCTRL+ALT+M = Trâccrbîh er têtto çelêççionao `n`nÊtto êh un poyêtto de codigo abierto y libre."
	Gui, Add, Picture, x10 y10 w119 h114, andalûh.png
	Gui, Add, Text, x+10 y10, %têhto%
	Gui, Add, Button, x130 y180 w120 h30 gOpenWebsite, Biçita Andalûh.es
	Gui, Add, Button, x270 y180 w120 h30 gOpenGithub, Github
	Gui, Show, w500 h350, AutoTranscribe 0.5
	return

	OpenWebsite:
	Run, https://andaluh.es
	return

	OpenGithub:
	Run, https://andaluh.es
	return

Return
}
; Splâ Imahen al iniçiâh la aplicaçion 
SplashImage = splash.png
SplashImageGUI(SplashImage, "Center", "Center", 1500, true)

; Môttrâh notificaçion al iniçiâh la aplicaçión
ShowNotification("AutoTranscribe", "Çe êtta ehecutando en çegundo plano.", 1500)

; Lemario pa çûttituçionê rápidâ 
subsFile := "subs.txt"
; Leêh er contenío der fixero en una bariable 
FileRead, csvContents, %subsFile%
; Dibidîh la bariable en una matrîh de filâ 
csvRows := StrSplit(csvContents, "`n")
; Creâh un array açoçiatibo baçío pa contenêh lô datô  
subs := {}
; Recorre lâ filâ y dibide cá fila en una matrîh açoçiatiba  
Loop % csvRows.Length()
{
    ; Dibidîh la fila en una matrîh açoçiatiba  
    csvRow := StrSplit(csvRows[A_Index], ",")

    ; Ôttenêh la clabe y er balôh de la fila âttuâh 
    key := csvRow[1]
    value := csvRow[2]

    ; Añade er pâh clabe-balôh a la matrîh açoçiatiba 
    subs[key] := value
}
; Êtta funçión çe encarga de creâh "Hotstrings" dinamicô pa podêh yebâh a cabo la çîttituçion de palabrâ. 
Hotstring(trigger, label, mode := 1, clearTrigger := 1, cond := ""){
	global $
	static keysBound := false,hotkeyPrefix := "~$", hotstrings := {}, typed := "", keys := {"symbols": "!""#$%&'()*+,-./:;<=>?@[\]^_``{|}~", "num": "0123456789", "alpha":"abcdefghijklmnopqrstuvwxyz", "other": "BS,Return,Tab,Space", "breakKeys":"Left,Right,Up,Down,Home,End,RButton,LButton,LControl,RControl,LAlt,RAlt,AppsKey,Lwin,Rwin,WheelDown,WheelUp,f1,f2,f3,f4,f5,f6,f7,f8,f9,f6,f7,f9,f10,f11,f12", "numpad":"Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"}, effect := {"Return" : "`n", "Tab":A_Tab, "Space": A_Space, "Enter":"`n", "Dot": ".", "Div":"/", "Mult":"*", "Add":"+", "Sub":"-"}
	
	if (!keysBound){
		;Bincula lâ teclâ pa bihilâh lô dîpparadorê.  
		for k,v in ["symbols", "num", "alpha"]
		{
			; alphanumeric/symbols
			v := keys[v]
			Loop,Parse, v
				Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring
		}
		
		v := keys.alpha
		Loop,Parse, v
			Hotkey, %hotkeyPrefix%+%A_Loopfield%,__hotstring
		for k,v in ["other", "breakKeys", "numpad"]
		{
			; balorê çeparáô por comâ  
			v := keys[v]
			Loop,Parse, v,`,
				Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring
		}
		keysBound := true ;keysBound êh una bariable êttática. Aora, lâ teclâ no çe bincularán dôh beçê. 
	}
	if (mode == "CALLBACK"){
		; Yamá de retônno pa lâ otkeys
		Hotkey := SubStr(A_ThisHotkey,3)
		if (StrLen(Hotkey) == 2 && Substr(Hotkey,1,1) == "+" && Instr(keys.alpha, Substr(Hotkey, 2,1))){
			Hotkey := Substr(Hotkey,2)
			if (!GetKeyState("Capslock", "T")){
				StringUpper, Hotkey,Hotkey
			}
		}
		
		shiftState := GetKeyState("Shift", "P")
		uppercase :=  GetKeyState("Capslock", "T") ? !shiftState : shiftState 
		; Çi er bloqueo de mayúcculâ êttá deçâttibao, la funçión de Mayúcculâ çe imbierte 
		; (ê deçîh, ar purçâh Mayúcculâ y una tecla mientrâ er bloqueo de mayúcculâ êttá âttibao, apareçerá la tecla minúccula).
		if (uppercase && Instr(keys.alpha, Hotkey)){
			StringUpper, Hotkey,Hotkey
		}
		if (Instr("," . keys.breakKeys . ",", "," . Hotkey . ",")){
			typed := ""
			return
		} else if Hotkey in Return,Tab,Space
		{
			typed .= effect[Hotkey]
		} else if (Hotkey == "BS"){
			; recortâ er tecleao bâh çi çe purçó Retroçeço. 
			StringTrimRight,typed,typed,1
			return
		} else if (RegExMatch(Hotkey, "Numpad(.+?)", numKey)) {
			if (numkey1 ~= "\d"){
				typed .= numkey1
			} else {
				typed .= effect[numKey1]
			}
		} else {
			typed .= Hotkey
		}
		matched := false
		for k,v in hotstrings
		{
			matchRegex := (v.mode == 1 ? "Oi)" : "")  . (v.mode == 3 ? RegExReplace(v.trigger, "\$$", "") : "\Q" . v.trigger . "\E") . "$"
			
			if (v.mode == 3){
				if (matchRegex ~= "^[^\s\)\(\\]+?\)"){
					matchRegex := "O" . matchRegex
				} else {
					matchRegex := "O)" . matchRegex
				}
			}
			if (RegExMatch(typed, matchRegex, local$)){
				matched := true
				if (v.cond != "" && IsFunc(v.cond)){
					; Çi la hotstring tiene una funçión de condiçión. 
					A_LoopCond := Func(v.cond)
					if (A_LoopCond.MinParams >= 1){
						; Çi la funçión tiene ar menô 1 parámetro.  
						A_LoopRetVal := A_LoopCond.(v.mode == 3 ? local$ : local$.Value(0))
					} else {
						A_LoopRetVal := A_LoopCond.()
					}
					if (!A_LoopRetVal){
						; Çi la funçión debuerbe un balôh no berdadero.  
						matched := false
						continue
					}
				}
				if (v.clearTrigger){
					; Eliminâh er dîpparadôh  
					SendInput % "{BS " . StrLen(local$.Value(0))  . "}"
				}
				if (IsLabel(v.label)){
					$ := v.mode == 3 ? local$ : local$.Value(0)
					gosub, % v.label
				} else if (IsFunc(v.label)){
					callbackFunc := Func(v.label)
					if (callbackFunc.MinParams >= 1){
						callbackFunc.(v.mode == 3 ? local$ : local$.Value(0))
					} else {
						callbackFunc.()
					}
				} else {
					toSend := v.label
				
					; Reçorbiendo lâ referençiâ cruçâh
					Loop, % local$.Count()
						StringReplace, toSend,toSend,% "$" . A_Index,% local$.Value(A_index),All
					toSend := RegExReplace(toSend,"([!#\+\^\{\}])","{$1}") ;Escape modifiers
					SendInput,%toSend%
				}
				
			}
		}
		if (matched){
			typed := ""
		} else if (StrLen(typed) > 350){
			StringTrimLeft,typed,typed,200
		}
	} else {
		if (hotstrings.HasKey(trigger) && label == ""){
			; Eliminando un hotstring. 
			hotstrings.remove(trigger)
		} else {
			; Añade al ôhheto hotstrings.
			hotstrings[trigger] := {"trigger" : trigger, "label":label, "mode":mode, "clearTrigger" : clearTrigger, "cond": cond}
		}
		
	}
	return

	__hotstring:
	; Êtta etiqueta çe âttiba cá bêh que çe purça una tecla. 
	Hotstring("", "", "CALLBACK")
	return
}
; Ehecutâh el interçêttadôh de teclâ
Run, keyboardhook.ahk 
;Run, keyboardhook.exe

; creamô el hotstring que çe dîpparará cá bêh que detêtte que una palabra termina en gion baho "_" independientemente de la cantidá de carâtterê
; una bêh dîpparao, êtta yama a la funçion replace(), la cuâ reemplaça er contenío de la palabra por la trâccrîççión al andalûh E.P.A. 
Hotstring("\w+_", "replace",3)
Return

replace($){
	; Palabrâ de âtta 5 letrâ que çe êccriben iguâh en câtteyano que en andalûh
    equibalenciâ := ["Ud._","Uds._","a_","ab_","aba_","ababa_","abale_","abane_","abano_","abata_","abate_","abato_","abete_","abeto_","abey_","abia_","abine_","abita_","abite_","abobe_","abofe_","abone_","abono_","aboye_","abra_","abran_","abre_","abren_","abro_","abrí_","abs_","abubo_","abure_","aca_","acabe_","acabo_","acala_","acame_","acara_","acare_","acata_","acate_","acaya_","acayo_","acle_","aco_","acoda_","acode_","acole_"]
		equibalenciâ.Push("acope_","acora_","acore_","acota_","acote_","acre_","acroe_","acroy_","acuda_","acude_","acudo_","acula_","acule_","acuna_","acune_","acure_","acuta_","acuto_","acuyo_","acá_","ad_","adala_","adame_","adara_","adela_","adema_","ademe_","adian_","adie_","adien_","adiá_","adié_","adió_","adoba_","adobe_","adora_","adore_","adra_","adran_","adre_","adren_","adrá_","adré_","adró_","adufa_","adufe_","adula_","adule_","aduna_","adune_")
		equibalenciâ.Push("aduro_","adán_","adó_","aeda_","aedo_","aena_","aeta_","afama_","afame_","afana_","afane_","afate_","afea_","afean_","afee_","afeen_","afera_","afere_","afero_","afeá_","afeé_","afeó_","afila_","afile_","afina_","afine_","aflua_","aflue_","afluo_","afofe_","afra_","afro_","afufa_","afufe_","afume_","afán_","afé_","afín_","agafa_","agafe_","agane_","agole_","agora_","agota_","agote_","agra_","agre_","agree_","agro_","agua_")
		equibalenciâ.Push("aguan_","aguao_","aguay_","aguda_","agudo_","ague_","aguen_","aguá_","aguó_","agá_","aipe_","airea_","airee_","airá_","airé_","airó_","aité_","aj_","al_","ala_","alaba_","alabe_","alaco_","alafa_","alala_","alale_","alalo_","alama_","alame_","alan_","alana_","alano_","alara_","alare_","ale_","alea_","alean_","aleda_","alee_","aleen_","alega_","alela_","alele_","alelo_","alem_","alema_","aleme_","alen_","alera_","alero_")
		equibalenciâ.Push("aleta_","aleto_","aleya_","aleá_","aleé_","aleó_","ali_","alico_","alifa_","alim_","aliá_","alié_","alió_","aloa_","alobe_","aloca_","alome_","alona_","alora_","alote_","aloya_","aluda_","alude_","aludo_","alum_","alune_","alá_","alán_","alé_","alén_","alía_","alíe_","alío_","aló_","alón_","alúa_","ama_","amaba_","amaga_","amala_","amale_","amalo_","amame_","aman_","amara_","amare_","amaru_","amate_","ambla_","amble_")
		equibalenciâ.Push("ambo_","ame_","ameba_","ameca_","amela_","amele_","amelo_","ameme_","amen_","amena_","ameno_","amere_","ami_","amia_","amiba_","amibo_","amida_","amiga_","amigo_","amina_","amine_","amino_","amito_","amomo_","amone_","ampay_","ampla_","amplo_","ampo_","ampre_","amufe_","amule_","amura_","amure_","amá_","amán_","amé_","amén_","amín_","amó_","amón_","an_","ana_","anaco_","anafe_","anata_","anay_","anaya_","anca_","ancla_")
		equibalenciâ.Push("ancle_","anco_","ancua_","anda_","andan_","ande_","anden_","ando_","andá_","anea_","anean_","anee_","aneen_","anega_","aneto_","aneá_","aneé_","aneó_","anfi_","angla_","anglo_","angra_","angú_","anida_","anide_","anima_","anime_","anita_","anito_","ano_","anoa_","anona_","anota_","anote_","anra_","anta_","ante_","anti_","antia_","antro_","anua_","anuda_","anude_","anula_","anule_","anuo_","anura_","anuro_","anón_","aonia_")
		equibalenciâ.Push("aonio_","aorta_","ap_","apa_","apaga_","apan_","apara_","apare_","apata_","apaya_","apea_","apean_","apee_","apeen_","apego_","apela_","apele_","apena_","apene_","apera_","apere_","apeá_","apeé_","apeó_","api_","apiay_","apila_","apile_","apio_","apipe_","apiri_","apite_","aplao_","apoca_","apoda_","apode_","apolo_","apona_","apono_","aporo_","apoya_","apoye_","aproe_","apu_","apulo_","apune_","apura_","apure_","apá_","apía_")
		equibalenciâ.Push("apón_","aque_","aquea_","aqueo_","aquia_","aquí_","ar_","ara_","araba_","arabo_","arala_","arale_","aralo_","arama_","arame_","aran_","arana_","arani_","arapa_","arara_","arare_","arca_","arcan_","arco_","arcá_","arcó_","arda_","ardan_","arde_","arden_","ardo_","ardua_","arduo_","ardé_","ardí_","are_","areca_","areco_","arela_","arele_","arelo_","areme_","aren_","arena_","arene_","arepa_","areta_","arete_","arfan_","arfe_")
		equibalenciâ.Push("arfen_","arfá_","arfé_","arfó_","argo_","aria_","arilo_","ario_","arma_","arman_","arme_","armen_","armá_","armé_","armó_","aroca_","aroma_","arome_","aromo_","aron_","arona_","arpa_","arpan_","arpe_","arpen_","arpeo_","arpá_","arpé_","arpó_","arq_","arque_","arra_","arre_","arrea_","arree_","arrue_","art_","arta_","arte_","arto_","aruba_","arupo_","ará_","arán_","aré_","aró_","ata_","ataba_","atabe_","ataca_")
		equibalenciâ.Push("atala_","atale_","atalo_","atame_","atan_","atape_","atara_","atare_","atate_","ate_","atean_","ateca_","atee_","ateen_","atela_","atele_","atelo_","ateme_","aten_","atena_","ateno_","ateo_","atete_","ateá_","ateé_","ateó_","atibe_","atila_","atina_","atine_","atipe_","atoa_","atoan_","atoba_","atoe_","atoen_","atole_","atoma_","atome_","atona_","atone_","atora_","atore_","atoá_","atoé_","atoó_","atraa_","atrae_","atrao_","atrio_")
		equibalenciâ.Push("atufa_","atufe_","atura_","ature_","atá_","atán_","até_","ató_","atún_","auca_","audio_","aula_","aun_","auná_","auné_","aunó_","aupá_","aupé_","aupó_","aura_","auto_","ax_","ay_","aya_","ayaco_","ayala_","ayate_","aymé_","ayna_","ayo_","ayora_","ayote_","ayto_","ayuda_","ayude_","ayuga_","ayuna_","ayune_","ayáu_","ayúa_","aína_","aíra_","aíre_","aíro_","aña_","año_","aún_","aúna_","aúne_","aúno_")
		equibalenciâ.Push("aúpa_","aúpe_","aúpo_","b_","baba_","babea_","babee_","babi_","babia_","bable_","baca_","badea_","baden_","baena_","bafea_","bafle_","baga_","bagan_","bago_","bagre_","bagua_","bagá_","bagó_","baifa_","baifo_","baila_","baile_","bala_","balan_","balay_","bale_","balea_","balee_","balen_","balá_","balé_","baló_","bamba_","bana_","banan_","banca_","banda_","bando_","bane_","banen_","bano_","banoy_","banyo_","baní_","bao_")
		equibalenciâ.Push("baque_","barba_","barbe_","barca_","barco_","barda_","barde_","baria_","bario_","baro_","barra_","barre_","barí_","barú_","bata_","batan_","bate_","batea_","batee_","baten_","batey_","bato_","batí_","baula_","baura_","baure_","baya_","bayo_","bayú_","baña_","bañe_","baño_","bco_","be_","beata_","beato_","beba_","beban_","bebe_","beben_","bebo_","bebé_","bebí_","beca_","becan_","becá_","becó_","befa_","befan_","befe_")
		equibalenciâ.Push("befen_","befre_","befá_","befé_","befó_","begum_","bela_","belio_","belua_","bemba_","bembe_","bembo_","ben_","beni_","beoda_","beodo_","beque_","berma_","berra_","berre_","berro_","berta_","beta_","beté_","beuda_","beudo_","beuna_","bey_","bi_","bibl_","bibí_","bidé_","biela_","bien_","bife_","biga_","bilao_","bilé_","bimba_","bina_","binan_","binde_","bine_","binen_","bingo_","biná_","biné_","binó_","bioma_","biota_")
		equibalenciâ.Push("biro_","birra_","bita_","bitan_","bite_","biten_","bitá_","bité_","bitó_","bla_","blago_","blao_","ble_","bleda_","bledo_","bleo_","bloca_","boa_","boato_","boba_","bobea_","bobee_","bobo_","boca_","bocoy_","boda_","bode_","boe_","boedo_","bofan_","bofe_","bofen_","bofia_","bofo_","bofá_","bofé_","bofó_","boga_","bogan_","bogá_","bogó_","boina_","boira_","bola_","bolea_","bolee_","boli_","bolo_","bomba_","bombo_")
		equibalenciâ.Push("bon_","bona_","bonda_","bonga_","bongo_","bono_","boom_","boque_","boqui_","borda_","borde_","boria_","boro_","borra_","borre_","borto_","bota_","botan_","bote_","botee_","boten_","botá_","boté_","botó_","bou_","boy_","boya_","boyan_","boye_","boyen_","boyá_","boyé_","boyó_","braca_","braco_","braga_","brama_","brame_","bran_","brea_","brean_","breca_","breco_","bree_","breen_","brega_","bren_","brete_","breá_","breé_")
		equibalenciâ.Push("breó_","briba_","bribe_","brida_","brin_","broa_","broca_","broma_","brome_","bromo_","brota_","brote_","brown_","brugo_","bruma_","brume_","brumo_","bruna_","bruno_","bruta_","bruto_","brío_","bs_","bu_","buaro_","buba_","bubi_","bucle_","buco_","buda_","bue_","buega_","buera_","buey_","bufa_","bufan_","bufe_","bufen_","bufeo_","bufia_","bufá_","bufé_","bufí_","bufó_","buga_","bugle_","buida_","buin_","bula_","bulan_")
		equibalenciâ.Push("bule_","bulen_","bulo_","bulá_","bulé_","bulí_","buló_","bum_","bunio_","buque_","bura_","burda_","burdo_","bureo_","burga_","burgo_","buri_","burio_","burka_","buro_","burra_","burro_","burí_","buró_","bute_","buten_","buyo_","bué_","byte_","búa_","búe_","c_","ca_","caa_","caan_","caba_","caban_","cabe_","cabee_","caben_","cabio_","cable_","cabo_","cabro_","cabé_","cabí_","caca_","cacao_","cacle_","caco_")
		equibalenciâ.Push("cacra_","cacuy_","cadi_","cado_","cadí_","cae_","caela_","caele_","caelo_","caeme_","caen_","caena_","cafre_","café_","caga_","cagan_","cagua_","cagá_","cagó_","caibe_","caico_","caiga_","caigo_","caima_","caimo_","caire_","cairo_","caite_","caió_","cala_","calan_","cale_","calen_","cali_","calá_","calé_","calí_","caló_","cama_","camao_","camba_","cambe_","cameo_","camie_","camio_","camp_","campa_","campe_","camá_","can_")
		equibalenciâ.Push("cana_","canco_","canda_","cande_","candi_","canea_","canee_","caney_","canga_","cania_","cano_","canoa_","canon_","canta_","cante_","cané_","cao_","caoba_","caobo_","capa_","capan_","cape_","capea_","capee_","capen_","capi_","capia_","capio_","capri_","capá_","capé_","capó_","caqui_","cara_","carao_","carau_","caray_","carba_","carca_","carda_","carde_","carea_","caree_","carey_","carga_","cari_","carme_","caro_","carpa_","carpe_")
		equibalenciâ.Push("carpo_","carra_","carro_","carta_","cata_","catan_","cate_","catea_","catee_","caten_","catey_","catre_","catru_","catá_","caté_","cató_","cauba_","cauca_","cauda_","caula_","cauno_","cauri_","cauro_","cauta_","cauto_","cay_","cayma_","cayna_","cayá_","cayó_","caé_","caí_","caía_","caín_","caña_","cañe_","caño_","ccapi_","cd_","cfe_","cgo_","cl_","claco_","clama_","clame_","clan_","clapa_","clara_","clare_","claro_")
		equibalenciâ.Push("cleda_","clema_","clero_","clica_","clima_","clin_","clo_","clon_","clona_","clone_","clora_","clore_","clota_","clube_","clubs_","cm_","co_","coa_","coana_","coata_","coate_","coba_","cobea_","cobla_","cobo_","cobra_","cobre_","coca_","coco_","cocui_","cocuy_","cocá_","cocó_","coda_","codea_","codee_","codo_","cofa_","cofia_","cofre_","cogua_","coima_","coime_","coipa_","coipo_","coite_","coito_","cola_","colan_","colea_")
		equibalenciâ.Push("colee_","colen_","coley_","colon_","colá_","colé_","coló_","colú_","com_","coma_","coman_","comba_","combe_","combi_","come_","comen_","como_","compa_","comta_","comto_","comé_","comí_","con_","conca_","conde_","conga_","congo_","cono_","conta_","coona_","coord_","copa_","copan_","cope_","copea_","copee_","copen_","copey_","copia_","copie_","copla_","copra_","copá_","copé_","copó_","coque_","cora_","corbe_","corca_","corco_")
		equibalenciâ.Push("corda_","core_","corea_","coree_","coren_","cori_","coria_","corma_","coro_","corpa_","corps_","corra_","corre_","corro_","corta_","corte_","corá_","coré_","corí_","coró_","coss_","cota_","cote_","cotee_","coto_","cotí_","cotó_","coy_","coya_","coín_","coña_","coño_","cpu_","cran_","crea_","crean_","credo_","cree_","creen_","crema_","creme_","creta_","creya_","creá_","creé_","creí_","creó_","criba_","cribe_","crica_")
		equibalenciâ.Push("crida_","cride_","crin_","crine_","criá_","crié_","crió_","croa_","croan_","croco_","croe_","croen_","crome_","cromo_","cron_","crono_","cross_","croto_","croá_","croé_","croó_","cruda_","crudo_","cría_","críe_","crío_","crúa_","crúo_","cta_","cte_","cu_","cuaba_","cuaco_","cuan_","cuando_","cuape_","cuark_","cuart_","cuata_","cuate_","cuba_","cubo_","cubra_","cubre_","cubro_","cuca_","cucan_","cucuy_","cucá_","cucó_","cucú_")
		equibalenciâ.Push("cueca_","cueco_","cuela_","cuele_","cuelo_","cuemo_","cuera_","cuero_","cuete_","cueto_","cui_","cuiba_","cuica_","cuico_","cuida_","cuide_","cuilo_","cuin_","cuina_","cuino_","cuita_","culea_","culee_","culi_","culo_","culé_","cuma_","cumba_","cumbe_","cumbo_","cumpa_","cuna_","cunan_","cunco_","cunda_","cunde_","cundo_","cune_","cunea_","cunee_","cunen_","cuná_","cuné_","cunó_","cuomo_","cuota_","cupe_","cupi_","cupo_","cupé_")
		equibalenciâ.Push("cuque_","cura_","curan_","curay_","curco_","curda_","curdo_","cure_","curen_","curia_","curie_","curio_","curp_","curra_","curre_","curry_","curta_","curte_","curto_","curá_","curé_","curí_","curó_","curú_","cuta_","cutan_","cute_","cuten_","cutio_","cuto_","cutra_","cutre_","cutí_","cuy_","cuya_","cuye_","cuyeo_","cuyo_","cuyá_","cuán_","cuña_","cuñe_","cuño_","có_","cómo_","cúa_","d_","da_","daba_","daban_")
		equibalenciâ.Push("dable_","daca_","dacá_","dadá_","daga_","dagua_","daifa_","dala_","dale_","dalia_","dalo_","dama_","dame_","dan_","danae_","dandi_","dando_","dango_","danta_","dante_","danto_","dapa_","dardo_","darga_","darme_","darte_","dará_","daré_","data_","datan_","date_","datem_","daten_","dateo_","datá_","daté_","dató_","dauco_","dañe_","daño_","dea_","deba_","deban_","debe_","deben_","debla_","deble_","debo_","debé_","debí_")
		equibalenciâ.Push("debó_","deca_","decaa_","decae_","decao_","dedeo_","dedo_","defie_","defua_","defue_","defuo_","del_","delia_","delio_","demo_","den_","dende_","denia_","denla_","denle_","denlo_","deo_","depre_","deque_","derbi_","deuda_","deudo_","deuto_","dey_","deán_","deñe_","di_","diana_","diay_","diego_","diera_","diere_","dieta_","diete_","diga_","digan_","digo_","dila_","dile_","dilo_","dilua_","dilue_","diluo_","dima_","diman_")
		equibalenciâ.Push("dime_","dimen_","dimo_","dimí_","din_","dina_","dinde_","dino_","dio_","diodo_","dique_","dirá_","diré_","dita_","dito_","ditá_","diu_","diuca_","diñe_","dni_","do_","dobla_","doble_","doca_","dodo_","doga_","dogo_","dogre_","doima_","dola_","dolo_","dolé_","dolí_","dom_","doma_","doman_","dombo_","dome_","domen_","domá_","domé_","domó_","don_","dona_","donan_","dond_","donde_","done_","donee_","donen_")
		equibalenciâ.Push("doneo_","doná_","doné_","donó_","dopa_","dopan_","dope_","dopen_","dopá_","dopé_","dopó_","dora_","doran_","dore_","doren_","doria_","dorio_","dorma_","dorme_","dormo_","dorta_","dorá_","doré_","doró_","dota_","dotan_","dote_","doten_","dotá_","doté_","dotó_","doy_","doña_","dpto_","dr_","dra_","draba_","draga_","drama_","drea_","drena_","drene_","drino_","droga_","dron_","drope_","drupa_","dría_","dto_","du_")
		equibalenciâ.Push("duba_","dubio_","duco_","duda_","dudan_","dude_","duden_","dudá_","dudé_","dudó_","duela_","duele_","duelo_","duena_","duero_","dueto_","dugo_","dula_","duma_","duna_","dunda_","dundo_","dupa_","dupla_","duplo_","duque_","dura_","duran_","dure_","duren_","durá_","duré_","duró_","duán_","dé_","dél_","déla_","déle_","délo_","déme_","dí_","día_","dña_","dúa_","dúo_","e_","ea_","ebria_","ebrio_","ebro_")
		equibalenciâ.Push("eco_","ecu_","ecua_","ecuo_","ed_","edema_","edila_","edipo_","edita_","edite_","edran_","edre_","edren_","edrá_","edré_","edró_","educa_","edén_","ef_","efe_","efebo_","efeto_","eflua_","eflue_","efluo_","egan_","ego_","eguan_","egue_","eguen_","eguá_","eguó_","eirá_","ej_","el_","elata_","elato_","ele_","elena_","eleta_","eleto_","elia_","elida_","elide_","elota_","elote_","eloy_","eluda_","elude_","eludo_")
		equibalenciâ.Push("emana_","emane_","eme_","emita_","emite_","emito_","empre_","emula_","emule_","emú_","en_","enana_","enano_","ende_","ene_","enea_","enema_","enero_","enfie_","enoye_","enrie_","enta_","ente_","enteo_","entlo_","entra_","entre_","eolia_","eolio_","epa_","epata_","epate_","epi_","epo_","epoda_","epodo_","epota_","epoto_","era_","eraba_","erala_","eran_","erara_","erare_","erbio_","ere_","erebo_","eren_","erg_","ergo_")
		equibalenciâ.Push("erina_","erman_","erme_","ermen_","ermá_","ermé_","ermó_","ero_","eroga_","erran_","erren_","errá_","erré_","erró_","eruga_","erute_","eruto_","erá_","eré_","ería_","erío_","eró_","et_","eta_","etano_","etapa_","eten_","etilo_","etola_","etolo_","eubea_","eubeo_","euro_","eñe_","eón_","fa_","faba_","faban_","fabio_","fabla_","fable_","fabo_","fabro_","faca_","fada_","fado_","faena_","faene_","fago_","fagua_")
		equibalenciâ.Push("fai_","faino_","falan_","falo_","fama_","fame_","fan_","fando_","fango_","fano_","fara_","faran_","farda_","farde_","fare_","faren_","faria_","fario_","faro_","faroe_","farpa_","farra_","farro_","farte_","fará_","faré_","fata_","fato_","fatua_","fatuo_","fauna_","fauno_","faya_","fañe_","fca_","fdo_","fe_","fea_","febea_","febeo_","feble_","febo_","febra_","feila_","feman_","feme_","femen_","femá_","femé_","femó_")
		equibalenciâ.Push("fen_","fenda_","fendi_","feo_","feota_","feote_","feren_","feria_","ferie_","fermi_","fero_","ferra_","ferre_","ferro_","ferry_","ferá_","feré_","ferí_","feta_","feto_","fetua_","feude_","feudo_","fi_","fiaba_","fiaca_","fiana_","fiara_","fiare_","fibra_","fican_","ficá_","ficó_","fida_","fideo_","fido_","fiemo_","fiera_","fiere_","fiero_","fifa_","fifan_","fife_","fifen_","fifé_","fifí_","fifó_","figle_","figo_","fila_")
		equibalenciâ.Push("filan_","file_","filen_","filia_","filie_","filin_","filá_","filé_","filó_","fimo_","fin_","fina_","finan_","finca_","fine_","finen_","finta_","finte_","finá_","finé_","finí_","finó_","fio_","fique_","firma_","firme_","fita_","fito_","fiyi_","fiá_","fié_","fiñe_","fió_","flaca_","flaco_","flama_","flan_","flato_","fleco_","flema_","fleme_","fleo_","fleta_","flete_","flipa_","flipe_","flora_","flore_","flota_","flote_")
		equibalenciâ.Push("flua_","fluan_","flue_","fluen_","flui_","fluo_","fluya_","fluye_","fluí_","fo_","fobia_","foca_","foco_","fofa_","fofo_","folia_","folie_","fome_","fon_","fona_","fonda_","fondo_","fonio_","fono_","fonte_","foque_","forca_","forma_","forme_","foro_","forra_","forre_","forte_","foto_","foya_","foyo_","fra_","frade_","fraga_","frao_","fray_","fredo_","frena_","frene_","freo_","frere_","frete_","frey_","frida_","friki_")
		equibalenciâ.Push("frita_","frite_","froga_","frota_","frote_","frua_","fruan_","frue_","fruen_","frui_","fruo_","fruta_","frute_","fruí_","fría_","frío_","fu_","fua_","fuan_","fuco_","fudre_","fue_","fuego_","fuen_","fuera_","fuere_","fuero_","fufan_","fufe_","fufen_","fufo_","fufá_","fufé_","fufó_","fufú_","fuga_","fugan_","fugá_","fugó_","fui_","fuida_","fuina_","fuió_","fula_","fuma_","fuman_","fume_","fumen_","fumá_","fumé_")
		equibalenciâ.Push("fumó_","funda_","funde_","fuo_","fura_","furia_","furo_","furte_","furto_","futre_","fuí_","fuía_","fuñe_","fá_","fé_","fí_","fía_","fían_","fíe_","fíen_","fío_","fó_","g_","gafa_","gafan_","gafe_","gafen_","gafá_","gafé_","gafó_","gago_","gagá_","gaira_","gaita_","gala_","galea_","galio_","galo_","gama_","gamba_","gamo_","gana_","ganan_","ganda_","gande_","gando_","gane_","ganen_","ganga_","ganta_")
		equibalenciâ.Push("gante_","ganá_","gané_","ganó_","gao_","gara_","garay_","garba_","garbe_","garbo_","garda_","gardo_","garfa_","garia_","gario_","garma_","garo_","garpa_","garpe_","garra_","garre_","garro_","garó_","gata_","gatea_","gatee_","gato_","gay_","gaya_","gayan_","gaye_","gayen_","gayo_","gayá_","gayé_","gayó_","gaña_","gañe_","gaño_","gaón_","glayo_","gleba_","glera_","glide_","glifo_","globo_","gluma_","gluon_","glía_","gnomo_")
		equibalenciâ.Push("gobio_","goda_","godeo_","godo_","godoy_","gofa_","gofio_","gofo_","gofre_","gogó_","gola_","golea_","golee_","goma_","goman_","gome_","gomen_","gomia_","gomá_","gomé_","gomó_","gong_","gongo_","gorda_","gordo_","gorga_","gorme_","gorra_","gorro_","gota_","gotea_","gotee_","goya_","goyo_","gps_","graba_","grabe_","grade_","grafo_","gram_","grama_","grame_","gramo_","gran_","grana_","grand_","grane_","grant_","grao_","grapa_")
		equibalenciâ.Push("grape_","grata_","grate_","grato_","grau_","gray_","greba_","greca_","greco_","greda_","green_","grelo_","greno_","grey_","grida_","gride_","grifa_","grife_","grifo_","grima_","gripa_","gripe_","grita_","grite_","gro_","groan_","groe_","groen_","grofa_","gromo_","groá_","groé_","groó_","gruan_","grue_","gruen_","grumo_","gruo_","grupa_","grupo_","gruta_","gruí_","grúa_","gta_","gua_","guaba_","guabo_","guaca_","guaco_","guala_")
		equibalenciâ.Push("guam_","guama_","guame_","guami_","guamo_","guane_","guano_","guao_","guapa_","guape_","guapo_","guara_","guare_","guaro_","guata_","guate_","guato_","guau_","guay_","guaya_","guaye_","gubia_","guera_","guero_","guey_","guila_","guilo_","guin_","guino_","guira_","guire_","guiro_","gula_","gulay_","gura_","gurda_","gurdo_","guro_","gurí_","gurú_","h_","i_","ib_","iba_","ibama_","iban_","ibero_","ibi_","ibón_","ica_")
		equibalenciâ.Push("icaco_","icono_","ida_","idea_","idean_","ideay_","idee_","ideen_","ideá_","ideé_","ideó_","ido_","iglú_","iguan_","igue_","iguen_","iguá_","iguó_","ilion_","iloca_","ilota_","iluda_","ilude_","iludo_","iló_","imam_","imane_","imbie_","imbua_","imbue_","imbuo_","imela_","imita_","imite_","imp_","impa_","impan_","impe_","impen_","impla_","imple_","impr_","impto_","impé_","impó_","imss_","imán_","in_","inane_","inca_")
		equibalenciâ.Push("incl_","incoa_","incoe_","inda_","india_","indio_","indo_","indé_","indú_","ine_","infla_","infle_","infí_","ing_","inga_","ingle_","ingre_","inope_","inri_","inti_","intua_","intue_","intuo_","iodo_","ion_","iota_","ipire_","iray_","irene_","irga_","irgan_","irgo_","irme_","irpa_","irra_","irrua_","irrue_","irruo_","irte_","iruto_","irá_","irán_","iré_","iría_","iró_","irún_","is_","issn_","ita_","ite_")
		equibalenciâ.Push("itera_","itere_","itria_","itrio_","ión_","k.o._","ka_","kaki_","kan_","karma_","kaua_","kendo_","kenia_","kepí_","kiko_","kili_","kilo_","kion_","kipá_","kirie_","kiwi_","km_","koala_","kong_","kurda_","kurdo_","l_","la_","labe_","labeo_","labia_","labio_","labra_","labre_","laca_","lacan_","lacra_","lacre_","lacó_","lada_","ladea_","ladee_","ladi_","ladra_","ladre_","lago_","lagua_","laica_","laico_","laida_")
		equibalenciâ.Push("laido_","lama_","laman_","lamay_","lamba_","lambe_","lambo_","lame_","lamen_","lamo_","lampa_","lampe_","lamé_","lamí_","lana_","lanan_","lanco_","landa_","lande_","lane_","lanen_","langa_","lanka_","lané_","lanó_","lapa_","lapo_","laque_","lara_","laran_","larco_","larda_","larde_","larga_","lari_","laria_","larra_","lata_","latae_","latan_","late_","latea_","latee_","laten_","lato_","latí_","lauda_","laude_","laudo_","launa_")
		equibalenciâ.Push("laura_","lauro_","lauta_","lauto_","lay_","laya_","layan_","laye_","layen_","layá_","layé_","layó_","laña_","lañe_","le_","lea_","leala_","leale_","lealo_","leame_","lean_","lebu_","leco_","leda_","ledo_","ledra_","ledro_","lee_","leela_","leele_","leelo_","leeme_","leen_","lefa_","lega_","legan_","legra_","legre_","legua_","legá_","legó_","leidi_","leila_","leima_","leió_","lela_","lelo_","lema_","lembo_","leme_")
		equibalenciâ.Push("lempo_","len_","lena_","lenca_","lene_","lenta_","lente_","lento_","leo_","leona_","lepe_","lepra_","lera_","lerda_","lerdo_","lerma_","lero_","letea_","leteo_","letra_","leuco_","leuda_","leude_","ley_","leyó_","leé_","leí_","leía_","leña_","leñe_","leño_","león_","liaba_","liana_","liara_","liare_","liba_","liban_","libe_","liben_","libia_","libio_","libra_","libre_","libá_","libé_","libó_","lican_","licra_","lidia_")
		equibalenciâ.Push("lidie_","liega_","liego_","liga_","ligan_","ligua_","ligá_","ligó_","lila_","lilao_","lilio_","lilo_","lima_","liman_","limbo_","lime_","limen_","limo_","limá_","limé_","limó_","lina_","linao_","linda_","linde_","linea_","linee_","linfa_","linio_","lino_","lio_","lipa_","lira_","liray_","liria_","lirio_","lita_","litan_","lite_","liten_","litio_","litre_","litro_","lituo_","litá_","lité_","litó_","liude_","liudo_","liá_")
		equibalenciâ.Push("lié_","liña_","liño_","lió_","lo_","loa_","loaba_","loara_","loare_","loba_","lobee_","lobo_","loca_","loco_","locro_","lodo_","lodra_","loe_","loen_","logan_","logra_","logre_","logá_","logó_","loica_","loina_","loli_","lolio_","lolo_","loma_","lomba_","lombo_","lomee_","lomo_","lona_","lonco_","longa_","longo_","lonya_","lope_","lora_","lorca_","lord_","loro_","lota_","lote_","lotee_","loteo_","loto_","loá_")
		equibalenciâ.Push("loán_","loé_","loó_","luan_","luca_","luco_","lucre_","lucro_","luda_","ludan_","lude_","luden_","ludia_","ludie_","ludio_","ludo_","ludí_","luego_","luen_","lugo_","lugre_","luió_","lula_","lulo_","lulú_","luma_","lumbo_","lumen_","lumia_","luna_","lunan_","lune_","lunen_","lunfa_","lunga_","lungo_","luné_","lunó_","luo_","lupa_","lupia_","luque_","lurin_","luro_","lurte_","luto_","luya_","luí_","luía_","lía_")
		equibalenciâ.Push("lían_","líe_","líen_","lío_","lúa_","lúe_","m_","mable_","mabí_","maca_","macan_","macau_","macla_","maco_","macro_","macá_","macó_","madre_","mafia_","maga_","mago_","magra_","magro_","maino_","maipo_","maito_","maku_","mala_","malea_","malee_","malo_","malí_","mam_","mama_","maman_","mambo_","mamby_","mame_","mamen_","mamey_","mamá_","mamé_","mamó_","man_","mana_","manan_","manca_","manda_","mande_","mane_")
		equibalenciâ.Push("manea_","manee_","manen_","manga_","manta_","mante_","manto_","manu_","manya_","manye_","maná_","mané_","maní_","manó_","maoma_","mapa_","mapea_","mapee_","mapo_","mapoy_","maque_","maqui_","mara_","marc_","marca_","marea_","maree_","marga_","mari_","mario_","maro_","maroa_","marra_","marre_","marta_","marte_","mata_","matan_","mate_","matea_","matee_","maten_","matá_","maté_","mató_","maula_","maule_","maura_","maure_","mauro_")
		equibalenciâ.Push("maya_","mayan_","maye_","mayee_","mayen_","mayo_","mayá_","mayé_","mayó_","maña_","maño_","me_","mea_","meaba_","mean_","meano_","meara_","meare_","meato_","meca_","meco_","meda_","media_","medie_","medo_","medra_","medre_","medí_","mee_","meela_","meele_","meelo_","meeme_","meen_","mega_","mego_","meiga_","meigo_","mela_","melan_","melen_","melua_","melá_","melé_","meló_","mema_","meme_","memo_","men_","mena_")
		equibalenciâ.Push("menan_","menda_","mene_","menea_","menee_","menen_","menga_","menta_","mená_","mené_","menó_","menú_","meona_","meran_","merca_","mere_","meren_","merey_","mergo_","merma_","merme_","mero_","merá_","meré_","meró_","meta_","metan_","mete_","meten_","meto_","metra_","metro_","meté_","metí_","meya_","meá_","meé_","meó_","meón_","mi_","miaba_","mialo_","miara_","miare_","miau_","mica_","micay_","mico_","micra_","micro_")
		equibalenciâ.Push("mida_","midan_","mide_","miden_","miedo_","miera_","miga_","migan_","migra_","migre_","migá_","migó_","mili_","milo_","mima_","miman_","mime_","mimen_","mimá_","mimé_","mimó_","mina_","minan_","minca_","minda_","minen_","minga_","minia_","minie_","miná_","miné_","minó_","mio_","mioma_","miona_","miope_","mira_","miran_","mire_","miren_","miria_","mirra_","mirto_","mirá_","miré_","miró_","mita_","mitin_","mito_","mitra_")
		equibalenciâ.Push("mitre_","mitú_","miura_","miá_","mié_","mió_","moa_","moble_","moca_","mocan_","moco_","mocoa_","mocá_","mocó_","moda_","modio_","modo_","mofa_","mofan_","mofe_","mofen_","mofla_","mofle_","moflo_","mofá_","mofé_","mofó_","moga_","mogo_","mola_","molan_","mole_","molen_","molá_","molé_","molí_","moló_","moma_","momee_","momia_","momio_","momo_","mona_","monda_","monde_","monea_","monee_","monga_","mongo_","moni_")
		equibalenciâ.Push("mono_","monra_","mons_","monta_","monte_","montt_","mopa_","moque_","mora_","moran_","morbo_","morca_","more_","moren_","morfa_","morfe_","morga_","morra_","morro_","morá_","moré_","morí_","moró_","mota_","mote_","motea_","motee_","moto_","motu_","moya_","moyo_","moái_","moña_","moño_","ms_","mtro_","mu_","mua_","muan_","muble_","muca_","mucan_","muco_","muda_","mudan_","mude_","muden_","mudá_","mudé_","mudó_")
		equibalenciâ.Push("mue_","mueca_","muela_","muele_","muelo_","muen_","muera_","muere_","muero_","mufa_","mufla_","mufle_","muflo_","muga_","mugan_","mugle_","mugre_","mugá_","mugó_","mui_","muita_","muito_","muió_","mula_","mule_","mulo_","mulá_","muna_","mundo_","muo_","muon_","muque_","mura_","muran_","mure_","muren_","murga_","muria_","murta_","murto_","murá_","muré_","muró_","muta_","mutan_","mute_","muten_","mutro_","mutua_","mutuo_")
		equibalenciâ.Push("mutá_","muté_","mutó_","mué_","muí_","muía_","muña_","muñe_","muño_","muón_","my_","mí_","mía_","mían_","míe_","míen_","mín_","mío_","n_","na_","naba_","nabla_","nabo_","nabí_","naca_","naco_","nacre_","nadan_","nade_","naden_","nadi_","nadie_","nadá_","nadé_","nadó_","nafa_","nafra_","nafre_","nagua_","naife_","naipe_","naire_","nairo_","nana_","nanay_","nanee_","nanga_","nango_","nano_","nante_")
		equibalenciâ.Push("nao_","napa_","napea_","napeo_","napia_","napo_","napí_","naque_","narco_","nardo_","nare_","narra_","narre_","nata_","nato_","natri_","nauca_","nauru_","nauta_","naya_","ne_","nea_","nebro_","nebí_","negra_","negro_","negua_","negá_","negó_","neira_","nema_","neme_","nemea_","nemeo_","nemon_","nen_","nena_","nendo_","nene_","nenia_","neo_","nepe_","neri_","neta_","neto_","neudo_","neuma_","neura_","neón_","ni_")
		equibalenciâ.Push("niara_","niata_","nicle_","nidia_","nidio_","nido_","niega_","niego_","niele_","nieta_","nieto_","nigua_","nilo_","nimbe_","nimia_","nimio_","nin_","ninfa_","ninfo_","nioto_","nipa_","niqui_","nito_","nitre_","niue_","niña_","niño_","no_","noble_","noca_","nocla_","nodo_","nolí_","noma_","nome_","nomo_","nomon_","non_","nona_","nonio_","nono_","noque_","nora_","noray_","noria_","norma_","norme_","norte_","nota_","notan_")
		equibalenciâ.Push("note_","noten_","notro_","notá_","noté_","notó_","noyó_","noé_","nro_","ntra_","nube_","nubia_","nubio_","nubla_","nuble_","nuca_","nuco_","nuda_","nudo_","nudra_","nudre_","nudro_","nuera_","nula_","nulo_","numen_","numo_","nunca_","nupa_","nuria_","nutra_","nutre_","nutro_","nuño_","ny_","nydia_","nylon_","nía_","núm_","o_","ob_","obelo_","obla_","oblan_","oble_","oblea_","oblen_","oblé_","obló_","oboe_")
		equibalenciâ.Push("obra_","obran_","obre_","obren_","obrá_","obré_","obró_","obué_","oc_","oca_","ocle_","oclua_","oclue_","ocluo_","ocoa_","ocopa_","ocote_","ocoyo_","ocre_","ocumo_","ocupa_","ocupe_","oda_","odia_","odian_","odie_","odien_","odiá_","odié_","odió_","odre_","odín_","odón_","ofita_","ofrio_","ogro_","oiba_","ok_","okupe_","ola_","olaya_","olea_","olean_","olee_","oleen_","olela_","olele_","olelo_","oleme_","olete_")
		equibalenciâ.Push("oleá_","oleé_","oleó_","olió_","olote_","olura_","oluta_","olé_","olí_","olía_","omate_","ombú_","omega_","omero_","omeya_","omia_","omine_","omita_","omite_","omito_","omán_","onda_","onde_","ondea_","ondee_","ondre_","ong_","ongon_","ongoy_","onoto_","onu_","op_","opa_","opaca_","opera_","opere_","opile_","opima_","opimo_","opina_","opine_","opio_","opona_","opone_","opono_","opón_","oque_","ora_","oraba_","orala_")
		equibalenciâ.Push("orale_","oralo_","orame_","oran_","orara_","orare_","orate_","orbe_","orca_","orco_","orden_","ore_","orea_","orean_","oree_","oreen_","orela_","orele_","orelo_","oreme_","oren_","oreá_","oreé_","oreó_","orfo_","orfre_","ori_","oribe_","orina_","orine_","orito_","oroya_","orto_","oruga_","oruro_","orá_","orán_","oré_","orí_","orín_","oró_","orón_","orú_","otaba_","otan_","otao_","otara_","otare_","ote_","otea_")
		equibalenciâ.Push("otean_","otee_","oteen_","oten_","otero_","oteá_","oteé_","oteó_","otile_","otoba_","otoca_","otra_","otre_","otri_","otro_","otá_","oté_","otó_","otú_","ox_","oyolo_","oyón_","oída_","oíla_","oíle_","oílo_","oíme_","p_","pabla_","pablo_","paca_","pacay_","paco_","pacoa_","pacú_","padre_","padua_","pafia_","pafio_","paga_","pagan_","pagro_","pagua_","pagá_","pagó_","paico_","paila_","paime_","paina_","paine_")
		equibalenciâ.Push("paipa_","paire_","pairo_","paita_","paito_","pala_","palau_","palay_","palea_","palee_","pali_","palo_","palé_","pam_","pamba_","pampa_","pamue_","pan_","pana_","panao_","panca_","panco_","panda_","pande_","pandi_","pando_","pane_","panea_","panee_","panga_","pano_","panti_","pao_","papa_","papan_","pape_","papea_","papee_","papen_","papi_","papá_","papé_","papó_","papú_","paran_","parao_","parca_","parco_","parda_","pardo_")
		equibalenciâ.Push("pare_","parea_","paree_","paren_","pargo_","parka_","parpe_","parra_","parre_","parro_","parta_","parte_","parto_","pará_","paré_","parí_","paró_","pata_","patao_","patay_","pate_","patea_","patee_","patio_","pato_","paté_","patí_","paula_","paule_","pauna_","pauta_","paute_","paya_","payan_","paye_","payen_","payoa_","payá_","payé_","payó_","paño_","pbro_","pc_","pdta_","pdte_","pe_","pea_","peala_","peale_","peana_")
		equibalenciâ.Push("pebre_","peca_","pecan_","pecá_","pecó_","pedio_","pedo_","pedro_","pedí_","peen_","pega_","pegan_","pegá_","pegó_","peina_","peine_","peió_","pela_","pelan_","pelao_","pele_","pelea_","pelee_","pelen_","pelá_","pelé_","peló_","pelú_","pena_","penan_","penca_","penco_","penda_","pende_","pendo_","pene_","penen_","peni_","pená_","pené_","penó_","peo_","peora_","peore_","pepa_","pepe_","pepla_","peplo_","pepú_","peque_")
		equibalenciâ.Push("pera_","perca_","perea_","peri_","pero_","perra_","perro_","perta_","perú_","peta_","petan_","pete_","peten_","petra_","petro_","petá_","peté_","petó_","peuco_","peumo_","peye_","peán_","peé_","peí_","peía_","peña_","peño_","peón_","pg_","pi_","piaba_","piafa_","piafe_","piala_","piale_","piano_","piara_","piare_","pibe_","pica_","pican_","picao_","picoa_","picuy_","picó_","pida_","pidan_","pide_","piden_","pifia_")
		equibalenciâ.Push("pifie_","pifo_","pigra_","pigre_","pigro_","pigua_","pila_","pilan_","pile_","pilen_","pilá_","pilé_","piló_","pin_","pina_","pinan_","pindo_","pine_","pinen_","pinga_","pingo_","pinra_","pinta_","pinte_","piné_","pinó_","pio_","piola_","piole_","pion_","piona_","pipa_","pipan_","pipe_","pipen_","pipi_","pipo_","pipá_","pipé_","pipí_","pipó_","pique_","pira_","piran_","piray_","pirca_","pirco_","pire_","piren_","piri_")
		equibalenciâ.Push("piro_","pirra_","pirre_","pirá_","piré_","piró_","pirú_","pita_","pitan_","pitao_","pite_","pitea_","pitee_","piten_","piti_","pitia_","pitio_","pitá_","pité_","pitó_","piula_","piule_","piune_","piura_","piure_","piá_","pié_","piña_","piño_","pió_","pión_","pl_","plaa_","placa_","plaga_","plan_","plana_","plano_","plata_","plato_","playa_","playo_","ple_","plebe_","pleca_","plena_","pleno_","pleon_","plepa_","plica_")
		equibalenciâ.Push("plim_","ploma_","plome_","plore_","pluma_","poa_","pobo_","pobra_","pobre_","poca_","poco_","poda_","podan_","pode_","poden_","podio_","podá_","podé_","podó_","poema_","poeta_","poete_","pola_","polan_","pole_","polea_","polen_","poleo_","poli_","polio_","polé_","polí_","poló_","pom_","poma_","pombo_","pomo_","pompa_","pompi_","pompo_","pon_","pona_","ponan_","pondo_","pone_","ponen_","ponga_","pongo_","poni_","pono_")
		equibalenciâ.Push("ponte_","ponto_","poné_","poní_","popa_","popan_","pope_","popen_","popá_","popé_","popó_","por_","pora_","porco_","pore_","poro_","poroy_","porra_","porro_","porta_","porte_","pota_","potan_","pote_","potea_","potee_","poten_","potra_","potro_","potá_","poté_","potó_","poya_","poyan_","poye_","poyen_","poyo_","poyá_","poyé_","poyó_","pp_","praga_","prao_","pre_","prea_","prean_","preda_","prede_","pree_","preen_")
		equibalenciâ.Push("prema_","preme_","premo_","preá_","preé_","preó_","prima_","prime_","prion_","pro_","proa_","proco_","profa_","profe_","prole_","prona_","prono_","prora_","proto_","pruna_","pruno_","pta_","pto_","pts_","pu_","puaba_","puara_","puare_","puda_","pudan_","pude_","puden_","pudin_","pudio_","pudo_","pudra_","pudre_","pudro_","pudu_","pudí_","pudú_","pueda_","puede_","puedo_","pufo_","puga_","pula_","pulan_","pule_","pulen_")
		equibalenciâ.Push("pulo_","pulí_","pum_","puma_","pumba_","pumbi_","puna_","punan_","punco_","puncu_","pune_","punen_","punga_","punk_","punki_","punta_","punte_","punto_","puná_","puné_","puní_","punó_","pupa_","pupan_","pupe_","pupen_","pupo_","pupu_","pupá_","pupé_","pupó_","pura_","purea_","puree_","purga_","puro_","purra_","purro_","puré_","puta_","putea_","putee_","puto_","putre_","puya_","puyan_","puyca_","puye_","puyen_","puyá_")
		equibalenciâ.Push("puyé_","puyó_","puá_","puán_","pué_","puñe_","puño_","puó_","pyme_","pía_","pían_","píe_","píen_","pío_","púa_","púan_","púe_","púen_","púo_","quark_","que_","queco_","queda_","quede_","quema_","queme_","quena_","queo_","quepa_","quepe_","quepo_","quera_","quero_","qui_","quia_","quico_","quien_","quila_","quili_","quilo_","quima_","quime_","quimo_","quin_","quina_","quino_","quipa_","quipo_","quipu_","quita_")
		equibalenciâ.Push("quite_","quitu_","qué_","quía_","quío_","r_","raa_","raan_","raba_","rabea_","rabee_","rabia_","rabie_","rabo_","rabí_","raco_","rada_","radia_","radie_","rae_","raela_","raele_","raelo_","raeme_","raen_","rafa_","rafe_","rafee_","rafia_","ragua_","ragú_","rain_","raió_","rala_","ralea_","ralee_","ralo_","rama_","ramio_","ramo_","rampa_","rampe_","rana_","rand_","randa_","rango_","rano_","rao_","rapa_","rapan_")
		equibalenciâ.Push("rape_","rapen_","rapá_","rapé_","rapó_","raque_","rara_","raree_","raro_","rata_","ratea_","ratee_","ratio_","rato_","rauca_","rauco_","rauda_","raudo_","rauta_","ray_","raya_","rayan_","raye_","rayen_","rayá_","rayé_","rayó_","raé_","raí_","raía_","raña_","raño_","rdo_","re_","rea_","reala_","reame_","reare_","reata_","reate_","reato_","reble_","recaa_","recae_","recao_","recle_","recre_","recua_","redan_","rede_")
		equibalenciâ.Push("reden_","redre_","redro_","redá_","redé_","redó_","regla_","regle_","regá_","regó_","reile_","reina_","reine_","relea_","relee_","releo_","relé_","rema_","reman_","reme_","remen_","remá_","remé_","remó_","ren_","renca_","renco_","renda_","rende_","rene_","renga_","rengo_","renio_","reno_","renta_","rente_","rené_","reo_","reoca_","repo_","reps_","reque_","reta_","retan_","rete_","reten_","retro_","retá_","reté_","retó_")
		equibalenciâ.Push("reuma_","rey_","reyan_","reye_","reyen_","reyá_","reyé_","reyó_","reí_","reía_","reña_","reñe_","reño_","riata_","riba_","rica_","rico_","riega_","riego_","riera_","riere_","rieto_","rifa_","rifan_","rife_","rifen_","rifle_","rifá_","rifé_","rifó_","rigua_","rigue_","rilan_","rile_","rilen_","rilá_","rilé_","riló_","rima_","riman_","rime_","rimen_","rimá_","rimé_","rimó_","rimú_","rin_","rinda_","rinde_","rindo_")
		equibalenciâ.Push("ripan_","ripia_","ripie_","rita_","rite_","rito_","riá_","riña_","ro_","roa_","roan_","roana_","roano_","roba_","roban_","robe_","roben_","robla_","roble_","robra_","robre_","robá_","robé_","robó_","roca_","roco_","roda_","rodao_","rodea_","rodee_","rodia_","rodio_","rodá_","rodé_","rodó_","roe_","roela_","roele_","roelo_","roeme_","roen_","roete_","roga_","rogan_","rogá_","rogó_","roió_","rola_","rolan_","role_")
		equibalenciâ.Push("rolen_","roleo_","rolá_","rolé_","roló_","roma_","rombo_","romea_","romeo_","romo_","rompa_","rompe_","rompo_","romí_","ron_","ronca_","ronda_","ronde_","roo_","ropa_","roqua_","roque_","roran_","rore_","roren_","rorro_","rorá_","roré_","roró_","rota_","rotan_","rote_","roten_","roto_","rotá_","roté_","rotó_","roya_","royó_","roé_","roí_","roía_","roña_","roñe_","rte_","ruaba_","ruan_","ruana_","ruano_","ruara_")
		equibalenciâ.Push("ruare_","rubia_","rubio_","rublo_","rubo_","rubra_","rubro_","rubí_","ruca_","rucan_","ruco_","rucá_","rucó_","ruda_","rudo_","rueca_","rueda_","ruede_","ruedo_","ruega_","ruego_","rufa_","rufo_","ruga_","rugan_","rugá_","rugó_","ruin_","ruina_","ruine_","rula_","rulan_","rule_","rulen_","rulá_","rulé_","ruló_","ruma_","rumba_","rumbe_","rumia_","rumie_","rumo_","rumí_","run_","runa_","runga_","rungo_","runo_","rupia_")
		equibalenciâ.Push("ruque_","ruta_","rutan_","rute_","ruten_","rutá_","ruté_","rutó_","ruá_","ruán_","rué_","ruñe_","ruó_","ría_","rían_","ríe_","ríen_","río_","rúa_","rúan_","rúe_","rúen_","rúo_","s_","sms_","sport_","sr_","sra_","sri_","srta_","ss_","sta_","stand_","statu_","sto_","swing_","t_","ta_","taba_","tabea_","tabio_","tabla_","table_","tabo_","tabí_","tabú_","tac_","taca_","tacan_","tacá_")
		equibalenciâ.Push("tacó_","tadeo_","tadó_","tafia_","tafo_","tafí_","tagua_","taifa_","taiga_","taima_","taime_","taina_","taipa_","taira_","taire_","taita_","tal_","tala_","talan_","tale_","talen_","talio_","talá_","talé_","taló_","tamba_","tambo_","tame_","tamo_","tan_","tanda_","tanga_","tanka_","tano_","tanta_","tanti_","tanto_","tao_","tapa_","tapan_","tapay_","tape_","tapea_","tapee_","tapen_","tapia_","tapie_","tapoa_","tapá_","tapé_")
		equibalenciâ.Push("tapó_","taque_","tara_","taran_","taray_","tarca_","tarco_","tarda_","tarde_","tare_","tarea_","taren_","tarma_","taroa_","tarra_","tarro_","tarta_","tará_","taré_","taró_","tata_","tatay_","tate_","tati_","tato_","tatú_","tau_","tauca_","taula_","tauro_","tayo_","taña_","taño_","te_","tea_","teabo_","teame_","teapa_","teayo_","tebea_","tebeo_","teca_","tecla_","tecle_","teclo_","teda_","tedie_","tedio_","tefe_","tegua_")
		equibalenciâ.Push("tegue_","teita_","tekom_","tela_","telan_","tele_","telen_","telé_","teló_","tema_","teman_","teme_","temen_","tempo_","temu_","temé_","temí_","temó_","ten_","tena_","tenca_","tenga_","tengo_","teno_","tente_","tenua_","tenue_","tenuo_","tené_","tepe_","tepuy_","tepú_","teque_","terai_","terca_","terco_","terma_","termo_","tero_","teta_","tetan_","tete_","teten_","tetra_","tetro_","tetá_","teté_","tetó_","teya_","teyo_")
		equibalenciâ.Push("teyú_","teña_","teñe_","teño_","tfno_","ti_","tiaca_","tiara_","tibe_","tibia_","tibie_","tibio_","tibú_","tico_","tie_","tiene_","tifa_","tifo_","tigra_","tigre_","tigue_","tila_","tile_","tilia_","tilo_","tima_","timan_","timba_","timbo_","time_","timen_","timpa_","timá_","timé_","timó_","tina_","tinca_","tineo_","tingo_","tino_","tinta_","tinte_","tinum_","tipa_","tipan_","tipea_","tipee_","tipi_","tiple_","tipo_")
		equibalenciâ.Push("tipoi_","tipoy_","tique_","tira_","tiran_","tire_","tiren_","tiria_","tirio_","tirro_","tirte_","tirá_","tiré_","tiró_","tite_","titea_","titee_","titen_","titi_","tito_","titá_","tité_","tití_","titó_","tiña_","tlaco_","tlapa_","to_","toa_","toaba_","toan_","toara_","toare_","toba_","tobia_","toca_","tocan_","tocá_","tocó_","toe_","toen_","tofo_","tofu_","toga_","togo_","tola_","tole_","tolo_","tolú_","toma_")
		equibalenciâ.Push("toman_","tomay_","tome_","tomen_","tomá_","tomé_","tomó_","ton_","tona_","tonan_","tonca_","tondo_","tone_","tonen_","tonga_","tongo_","tono_","tonta_","tonto_","toná_","toné_","tonó_","topa_","topan_","tope_","topee_","topen_","topia_","topá_","topé_","topó_","toque_","toqui_","tora_","torca_","torco_","torda_","tordo_","torea_","toree_","torga_","torgo_","torio_","tormo_","toro_","torpe_","torra_","torre_","torta_","tota_")
		equibalenciâ.Push("tote_","totí_","tours_","toá_","toé_","toña_","toó_","tpo_","traa_","traan_","traba_","trabe_","traca_","trae_","traen_","trafa_","traga_","trama_","trame_","trans_","trao_","trapa_","trape_","trapo_","traro_","trata_","trate_","traé_","traí_","trebo_","trefe_","trema_","tren_","trena_","treno_","treo_","trepa_","trepe_","treta_","tri_","tribu_","triga_","trigo_","trile_","trina_","trine_","tripa_","tripe_","trita_","triá_")
		equibalenciâ.Push("trié_","trió_","trola_","trole_","trolo_","trona_","tropa_","tropo_","trota_","trote_","troy_","troya_","truca_","trufa_","trufe_","trun_","trué_","tría_","tríe_","trío_","tuani_","tuba_","tubo_","tuca_","tuco_","tuda_","tueca_","tueco_","tueme_","tuera_","tuero_","tufo_","tui_","tuina_","tula_","tule_","tulia_","tulio_","tulum_","tuman_","tumay_","tumba_","tumbe_","tumo_","tun_","tuna_","tunan_","tunca_","tunco_","tunda_")
		equibalenciâ.Push("tunde_","tundo_","tune_","tunea_","tunee_","tunen_","tunta_","tuná_","tuné_","tunó_","tupa_","tupan_","tupe_","tupen_","tupo_","tupé_","tupí_","tura_","turan_","turba_","turbe_","turca_","turco_","ture_","turen_","turia_","turma_","turpe_","turpo_","turra_","turre_","turro_","turua_","turá_","turé_","turó_","tuta_","tute_","tutea_","tutee_","tuti_","tuto_","tutú_","tuy_","tuya_","tuyo_","tuyú_","té_","tía_","tío_")
		equibalenciâ.Push("tú_","u_","uayma_","ube_","ubica_","ubio_","ubre_","ubí_","uco_","ucú_","ud_","uf_","ufa_","ufane_","ufano_","ufo_","ufugu_","ugre_","ulaga_","ulala_","ulano_","ulema_","ulua_","ulula_","ulule_","umane_","umari_","umbra_","umbro_","umero_","umán_","un_","una_","unala_","unale_","unalo_","uname_","unan_","unda_","une_","unen_","unila_","unile_","unilo_","unime_","unite_","unió_","uno_","unta_","untan_")
		equibalenciâ.Push("unte_","unten_","untá_","unté_","untó_","uní_","unía_","upa_","upaba_","upala_","upale_","upalo_","upame_","upan_","upara_","upare_","upata_","upe_","upela_","upele_","upelo_","upeme_","upen_","upupa_","upá_","upé_","upía_","upó_","ura_","uraca_","urama_","urano_","urao_","urape_","urato_","urbe_","urbi_","urca_","urda_","urdan_","urde_","urden_","urdo_","urdu_","urdí_","urea_","uro_","urpay_","urrao_","urss_")
		equibalenciâ.Push("urta_","urudo_","uruga_","urán_","uré_","urú_","ut_","uta_","uy_","uyuni_","uña_","uñan_","uñe_","uñen_","uñi_","uño_","uñon_","uñí_","wanda_","webs_","wide_","wifi_","y_","ya_","yaba_","yaca_","yaeé_","yagua_","yak_","yale_","yalí_","yamao_","yambo_","yamon_","yampa_","yana_","yang_","yanga_","yanta_","yante_","yapa_","yapan_","yape_","yapen_","yapá_","yapé_","yapó_","yapú_","yaqui_","yarda_")
		equibalenciâ.Push("yare_","yarey_","yaro_","yarí_","yatay_","yate_","yatra_","yauca_","yauli_","yauya_","yaya_","yayo_","yaá_","ye_","yebo_","yecla_","yeco_","yedra_","yegua_","yema_","yemen_","yen_","yendo_","yente_","yerba_","yerga_","yergo_","yerma_","yerme_","yero_","yerra_","yerre_","yerro_","yerta_","yerto_","yeta_","yeti_","yeyo_","yeyé_","yin_","yina_","yira_","yiro_","yo_","yodo_","yoga_","yogan_","yogo_","yogá_","yogó_")
		equibalenciâ.Push("yola_","yonan_","yori_","york_","yotao_","yoyo_","yoyó_","yuan_","yubo_","yuca_","yucay_","yudo_","yugo_","yumba_","yumbo_","yunga_","yunta_","yunte_","yunto_","yupan_","yura_","yuri_","yurua_","yuré_","yurí_","yuta_","yute_","yuto_","yuy_","yuyo_","z_","ál_","áloe_","área_","él_","énea_","éneo_","íd_","ídem_","íleo_","ítem_","ña_","ñame_","ñapa_","ñata_","ñato_","ñeco_","ñipe_","ñire_","ño_")
		equibalenciâ.Push("ñora_","ñoro_","ñu_","ñudo_","ñuta_","ñuto_","ó_","óleo_")

	
	
	word := RegExReplace($.Value(0), "_", "") ; reemplaçamô er gion baho de la palabra êccrita
	trigger := $.Value(0) ; borcamô er contenío a una bariable pa podêh uçâl-la çin tantâ complicaçionê en la çintâççî.
	; Comprobamô çi la palabra empieça con mayúccula
	is_uppercase := false
	if (SubStr(trigger, 1, 1) ~= "^[A-Z]") {
		is_uppercase := true
	} else {
		is_uppercase := false
	}

	; comprobamô çi er balôh êççîtte en el array de equibalençiâ
    if (HasVal(equibalenciâ, trigger)){
			;  aplicando mayúccula
			if(is_uppercase){
					word := Chr(Asc(SubStr(word, 1, 1)) - 32) . SubStr(word, 2)
				}
			Send, %word%%Clipboard% ; emô encontrao la equibalençia y embiamô er balôh corrêppondiente.
			Return
		}
	else {
		; No emô encontrao un balôh anteriormente, açi que lo bûccaremô en la array açoçiatiba subs
		global subs ; declaramô la bariable pa âççeço globâh

		if (subs.HasKey(trigger)){
				; Emô encontrao er balôh en la array, y çûttituimô er dîpparadôh por el reçurtao ôttenío.
				myValue := subs[trigger]
				myValue := StrReplace(myValue, "`r", "", 1) 
				myValue := StrReplace(myValue, "`n", "", 1)
				;  aplicando mayúccula
				if(is_uppercase){
					myValue := Chr(Asc(SubStr(myValue, 1, 1)) - 32) . SubStr(myValue, 2)
				}
				Send, %myValue%%Clipboard%
				Return
			}
		else {
			; Er balôh no êttaba en el array, açi que açemô una yamá al ehecutable der trâccrîttôh, y reçibimô el reçurtao
			cmd := A_ScriptDir . "\andaluh-cli.exe " . """" word . """"
			shell := ComObjCreate("WScript.Shell")
			exec := shell.Exec(ComSpec " /C " cmd )
			andaluh := exec.StdOut.ReadAll()
			my_string := StrReplace(andaluh, "([\t\s\n]+)", "")
			ValorLimpio := StrReplace(andaluh, "`r", "", 1) 
			ValorLimpio := StrReplace(ValorLimpio, "`n", "", 1)
			;  aplicando mayúccula
			if(is_uppercase){
					ValorLimpio := Chr(Asc(SubStr(ValorLimpio, 1, 1)) - 32) . SubStr(ValorLimpio, 2)
				}
			Send,  %ValorLimpio%%Clipboard%
			; Añadimô er balôh a la array çubs pa aumentâh la beloçidá y reduçîh er côtte computaçionâh.
			subs[trigger] := ValorLimpio . " "
			; yamamô a la funçion que guarda la trâccrîççion en er fixero subs.txt
			GuardaEnDatabase(trigger, ValorLimpio)
		}
	}
	
	Return
}


GuardaEnDatabase(trigger, my_string){
	textToAppend := trigger . "," . my_string
	ShowNotification(my_string . "!", "Çe a guardao la palabra " . my_string . " en er lemario pa mehorâh la beloçidá.", 2000)
	Run, filehandler.ahk %textToAppend%, , UseErrorLevel 
	Return
}

stdOutToVar(command) {
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /C " command )
    result := exec.StdOut.ReadAll()
    return result
}

andaluh(selected_text) {
    cmd2 := A_ScriptDir . "\andaluh-cli.exe " . """" selected_text . """"
    andaluh := stdOutToVar(cmd2)
    andaluh := RTrim(andaluh, OmitChars = " \`t\`r\`n")
    Send, %andaluh%{BS 2}
    return
}

reemplazar(value){
    cmd2 := A_ScriptDir . "\andaluh-cli.exe " . """" value . """"
    andaluh := stdOutToVar(cmd2)
    andaluh := RTrim(andaluh, OmitChars = " \`t\`r\`n")
    Send, %andaluh%{BS 2}
    return
}

HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
	  return 0
	for index, value in haystack
	  if (value = needle)
		return index
	return 0
}

ShowNotification(title, message, duration) {
    ; Môttrâh una notificaçión mediante TrayTip
    TrayTip, % title, % message, % duration
}

SplashImageGUI(Picture, X, Y, Duration, Transparent = false){
	Gui, XPT99:Margin , 0, 0
	Gui, XPT99:Add, Picture,, %Picture%
	Gui, XPT99:Color, ECE9D8
	Gui, XPT99:+LastFound -Caption +AlwaysOnTop +ToolWindow -Border
	If Transparent
	{
	Winset, TransColor, ECE9D8
	}
	Gui, XPT99:Show, x%X% y%Y% NoActivate
	SetTimer, DestroySplashGUI, -%Duration%
	return

	DestroySplashGUI:
	Gui, XPT99:Destroy
	return
}

CloseScript(Name)
	{
	DetectHiddenWindows On
	SetTitleMatchMode RegEx
	IfWinExist, i)%Name%.* ahk_class AutoHotkey
		{
		WinClose
		WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , 2
		If ErrorLevel
			return "Unable to close " . Name
		else
			return "Closed " . Name
		}
	else
		return Name . " not found"
	}