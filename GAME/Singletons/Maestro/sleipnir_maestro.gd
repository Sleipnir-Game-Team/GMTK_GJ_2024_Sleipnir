## Sleipnir Global Music Player
##
## [color=orange]ATENÇÃO[/color] Measure e Bar são a mesma coisa. 
## estes termos são usados alternando durante esse código [br]
## Musicas são salvas como 2 resources:[br]
## - [code]song_name_triggers.tres[/code] para os clips tipo trigger [br]
## - [code]song_name_main.tres[/code] para os clips principais [br][br]
## Esses resources são então carregados no SleipnirMaestro, e tocados. [br] 
## onde um [AudioStreamInteractive] é responsável pela transição das músicas. [br]
extends Node

signal beat(position:int, time:float) ## manda a beat atual 
signal measure(position:int, time:float) ## manda a measure atual

@export_category("Config Geral") # Configurações relacionadas a música
@export var MainPlayer : AudioStreamPlayer        ## [AudioStreamPlayer] que cuida dos clips principais
@export var TriggerPlayer : Node                  ## [AudioStreamPlayer] que cuida dos clips de trigger
@export var Clock : Timer                         ## Clock para contar tempo musical 
@export_subgroup("Debug")
## Ativar logging no output
@export_enum("ALL","DEBUG","INFO","WARN","ERROR","FATAL","OFF") var log_level : int = 2        

# tempo
var BPM : int                                     ## Beats per Minute
var BeatsPerBar : int                             ## Beat em 1 até infty (só n abusa)
var SPB : float                                   ## Seconds Per Beat

# monitoring
var elapsed_measures : int = 1     ## conta as barras
var elapsed_beats : int = 1         ## conta beats sempre relativo a Time Signature
var current_section : String        ## em que sessão estamos?
# ATTENTION Não esquecer de verificar isso ^^
var current_song : String = "none"  ## musica atual

# private
var _trigger_stems : Array             # stems trigger
var _currently_playing_trigger : Array # triggers tocando
var _transition_type : int             # qual transição vai rolar
var _last_bar_time : float             # quando a ultima bar tocou
var _last_beat_time : float            # quando a ultima beat tocou
var _silence_path : String = "res://Singletons/Maestro/silence-500ms.mp3"  # path do placeholder de silencio
var _song_path : String = "res://Assets/Placeholder/MusicalLayers Level PlaceHolder/" # path das músicas
var _sync_streams : Array[int]         #ATTENTION é pra ser dicionário de streams pro AudioStreamSync  

# funções públicas VVVVVVVVV
## da o play
func play() ->void :
	if current_song == "none":        # se não tem musica carregada retorna
		Logger.warn("there's no song here!")
		return
	if (MainPlayer.is_playing() == true): # se já estiver tocando retorna
		Logger.warn("song already playing!")
		return
	Clock.start()     # começa o conductor
	MainPlayer.play() # da play

## chama um clip e da play nele    
func trigger(clip_name: String, sync_method: int=0) ->void :
	if (MainPlayer.is_playing() == false): # se não estiver tocando retorna
		Logger.warn("can't play when song is not playing")
		return
	if current_song == "none":     # se não tem musica carregada retorna
		if log_level <=3: Logger.warn("there's no song here!")
		return
	if _trigger_stems.has(clip_name) == false: # se não tem o trigger chamado
		if log_level <=3: Logger.warn("there's no trigger with the name \""+clip_name+"\"")
		return

	var TriggerStem = get_node("/root/SleipnirMaestro/Triggers/" + clip_name)
	_trigger_play(TriggerStem,sync_method) ## WARNING TESTAR BEM.
	_currently_playing_trigger.append(TriggerStem)
	await TriggerStem.finished
	if log_level <=1: Logger.debug("finished playing: " + TriggerStem.name)
	_currently_playing_trigger.erase(TriggerStem)

## para tudo
func stop() ->void : 
	if current_song == null: # se não tiver musica, retorna
		Logger.warn("there's no song here!")
		return
	if MainPlayer.is_playing() == false: # se já nao estiver tocando, retorna
		Logger.warn("The Song is not playing! can't stop what's not happening")
		return
	MainPlayer.stop() # para musica
	Clock.stop()      # para clock
	if _currently_playing_trigger.size() != 0: # para os triggers
		for TriggerStem in _currently_playing_trigger:
			TriggerStem.stop()
			_currently_playing_trigger.erase(TriggerStem)

## pausa tudo
func pause() ->void :
	if current_song == "none": #se não tem musica tocando retorna
		Logger.warn("there's no song here!")
		return 
	if MainPlayer.get_stream_paused() == true: # se não estiver pausado, retorna
		Logger.warn("song already paused!")
		return
	MainPlayer.set_stream_paused(true) # pausa musica
	Clock.set_paused(true) # pausa clock
	if _currently_playing_trigger.size() != 0: # pausa trigger 
		for TriggerStem in _currently_playing_trigger:
			TriggerStem.set_stream_paused(true)

## resume o pause
func resume() ->void :
	if current_song == "none": # se não tem musica tocando, retorna
		Logger.warn("there's no song here!")
		return 
	if MainPlayer.get_stream_paused() == false: # se não estiver pausado, retorna
		Logger.warn("song already playing!")
		return
	Clock.set_paused(false) # resume clock
	MainPlayer.set_stream_paused(false) # resume musica
	if _currently_playing_trigger.size() != 0:
		for TriggerStem in _currently_playing_trigger:
			
			TriggerStem.set_stream_paused(false)
		

## muda de sessão
func switch_section(new_section: String) ->void :
	# log informando tipo de transição
	if log_level <=1 : Logger.debug("transition type é: "+str(_transition_type)) 
	
	# se quiser mudar pra sessão atual, retorna
	if current_section == new_section:
		Logger.warn("can't switch to the same section")
		return
	# se não tiver musica, retorna
	if current_song == "none": 
		push_error("there's no song here!")
		return
	# se estiver pausado ou parado, retorna
	if (MainPlayer.is_playing() == false) and (MainPlayer.get_stream_paused() == false):
		Logger.warn("can't switch to section when stopped or paused!")
		return	
	
	# log que avisa pra onde vai 
	if log_level <=2 : Logger.info("will switch to "+ new_section +" ["+str(_get_elapsed_time())+" s]") 
	# se deu tudo certo, checa o tipo de transição
	match _transition_type: 
		2: # se for por bar
			_switch_by_bar(new_section) # usar o método custom de transição
		_: # se for qualquer outra
			MainPlayer.set("parameters/switch_to_clip", new_section) # usa o default
			current_section = new_section
			if log_level <=1: Logger.debug(current_section+" ["+str(_get_elapsed_time())+" s]")	
# ATTENTION DEFAULT FIRST SECTION ESTÁ ATIVO ^^

func toggle_layer(SyncStream:int) ->void:
	var MainStream : Variant = MainPlayer.get_stream()
	if MainStream is not AudioStreamSynchronized:
		if log_level <= 3 : Logger.warn("can't toggle unless is AudioStreamSynchronized")
		return
	#var SyncStream : int = _sync_streams[name]
	var old : float = MainStream.get_sync_stream_volume(SyncStream)
	var new : float
	if old != -60:
		new = -60
	elif old != 0.0:
		new = 0.0
	if log_level<=1: Logger.debug("Stream of Number: "+str(SyncStream)+" from "+str(old)+" to "+str(new))
	if log_level<=1: Logger.debug("BeatsPerBar: "+str(BeatsPerBar)+", SPB: "+str(SPB)+", BPM: "+str(BPM))
	var gain_control = func(tweener:float):
		MainStream.set_sync_stream_volume(SyncStream,tweener)
	
	var fader = create_tween()
	#if fader.is_running() == true:
	#	fader.parallel().tween_method(gain_control,old,new,(SPB*BeatsPerBar))
	fader.tween_method(gain_control,old,new,(SPB*BeatsPerBar))
	if log_level <=2 : Logger.info("Toggled "+str(MainStream.get_sync_stream(SyncStream)))

	
## muda de música
func change_song(song_name:String) ->void: # TODO FAZER COM QUE A MUSICA CONTINUE TOCANDO QUANDO MUDA
	if Clock.is_stopped() == false: # se o clock não está parado, para
		Clock.stop() 
	if TriggerPlayer.get_child_count() != 0: # se tiver trigger, tira
		_trigger_remove()
		_trigger_stems = []
	_sync_streams.clear()
	# carrega o resource da musica
	var song_data = load(_song_path+song_name+".tres")
	_data_handling(song_data) # distribui os dados onde precisa
	elapsed_measures = elapsed_measures # seta as measures
	current_song = song_name
	if log_level < 3:
		Logger.info("[SleipnirMaestro] "+str(current_song)+" Ready! at "+str(BPM)+" BPM or "+ str(SPB) +" SPB")

func _ready() -> void:
	if Clock.one_shot != false: # só pra garantir o clock n tocar só uma vez
		Clock.one_shot = false
	#var _measure_tracker = Callable(self,"_measure_tracker")
	#measure.connect(_measure_tracker)
	if TriggerPlayer.get_child_count() != 0: # se tiver algum trigger aqui, remover
		_trigger_remove()                

# método custom de transição por barra
func _switch_by_bar(bar_name: String ,offset : int = 0) -> void:
		# tempo para uma barra/measure
		var bar_time: float = SPB*BeatsPerBar                
		# previsão de quando é a próxima barra
		var next_bar = (_last_bar_time + bar_time)+(offset*SPB) 
		# o tempo em que vai ser feita a transição
		var switch_time : float = next_bar - snappedf(_get_elapsed_time(),SPB)
		
		if log_level <=1 : # Log pra saber onde vai transicionar
			Logger.debug("last_bar_time ["+str(_last_bar_time)+" s]")
			Logger.debug("next_bar_time ["+str(next_bar)+" s]") 
		
		await get_tree().create_timer(abs(switch_time)).timeout # Espera o switch_time
		
		if log_level <= 1: # Log avisando que vai transicionar
			Logger.info("switching now ["+str(_get_elapsed_time())+" s]")
		
		MainPlayer.set("parameters/switch_to_clip", bar_name) # Transiciona pra sessão
		current_section = bar_name # muda qual sessão estamos no codigo
		
		if log_level <= 1: # Log após transicionar, pra dizer quando e pra onde
			Logger.debug(current_section+" ["+str(_get_elapsed_time())+" s]")	

# o que acontece quando o conductor conta 1 Beat
func _on_conductor_timeout() -> void:
	elapsed_beats += 1                            # Adiciona ao elapsed_beats
	_last_beat_time = _get_elapsed_time()
	if elapsed_beats == BeatsPerBar+1:            # Checa se não finalizou uma Measure
		emit_signal("measure", elapsed_measures,_get_elapsed_time())  # Emite sinal de finalizar Measure
		elapsed_measures += 1                     # Adiciona ao elapsed_measures
		_last_bar_time = _get_elapsed_time()
		elapsed_beats = 1                         # Reseta o timer de beats
	if log_level < 2: # Log informando tempo musical
		Logger.debug(str(elapsed_measures)+"Bar "
		+str(elapsed_beats)+"Beat "
		+"["+str(_get_elapsed_time())+" s]")
	emit_signal("beat", elapsed_beats,_get_elapsed_time())            # Emite o sinal de finalizar uma Beat	

# função para pegar os dados e popular o player Main e os Triggers
func _data_handling(song_data:Resource) -> void:
	var fade_mode  : int 
	var fade_beats : float 
	match song_data.MainClips.get_class():
		"AudioStreamInteractive":
			current_section = song_data.get_first_section()             # pega qual a sessão default da música
			MainPlayer.set("parameters/switch_to_clip",current_section) # seta a sessão pra ela
			MainPlayer.set_stream(song_data.get_main_clips())           # seta a stream pro MainPlayer
			_transition_type = song_data.get_track_transition()         # pega qual transição é usada entre os clips da musica
			fade_mode = song_data.get_fade_mode()                       # pega qual o fade_mod
			fade_beats = song_data.get_fade_beats()                     # pega em quanto faz o fade
			# se a transição for feita por barras, seta como imediato pra poder usar o metodo custom
			if _transition_type == 2:
				MainPlayer.get_stream().add_transition(-1,-1,0,0,fade_mode,fade_beats)
			# caso não seja, apenas usa a forma padrão
			else:
				MainPlayer.get_stream().add_transition(-1,-1,_transition_type,0,fade_mode,fade_beats)
		"AudioStreamSynchronized":
			MainPlayer.set_stream(song_data.get_main_clips())           # seta a stream pro MainPlayer
			_get_sync_streams(song_data.get_main_clips())
		"AudioStreamPlaylist": 
			MainPlayer.set_stream(song_data.get_main_clips())           # seta a stream pro MainPlayer
		_:
			Logger.error("Invalid AudioStream", get_stack())
			MainPlayer.set_stream(_load_mp3())
	
	_get_bpm(song_data)                               # seta o BPM pro clock		
	
	if song_data.has_trigger_clips == true:      # se tem trigger
		var trigger_clips : Array = song_data.get_trigger_clips() # seta a stream pro trigger
		_trigger_populate(trigger_clips)

	else:                                        # se não tem , retorna
		return
# ATTENTION DEFAULT FIRST SECTION ESTÁ ATIVO

# pega o BPM para usar no clock
# usado no _data_handling()
func _get_bpm(song_data:Resource) -> void: 
	var first_stream : Variant # Seta o conductor para o tempo certo
	
	if MainPlayer.stream is AudioStreamInteractive:
		first_stream = MainPlayer.stream.get_clip_stream(0) # pega o primeiro clip do main
	elif MainPlayer.stream is AudioStreamSynchronized:
		first_stream = MainPlayer.stream.get_sync_stream(0) # pega o primeiro clip do main
	elif MainPlayer.stream is AudioStreamPlaylist:
		first_stream = MainPlayer.stream.get_list_stream(0) # pega o primeiro clip do main
	
	var reference_stream # variável que vai ser usada para pegar bpm
	
	# checa a classe da primeira AudioStream
	match first_stream.get_class(): 
		# caso seja qualquer uma dessas 3, chama o método para pegar a primeira stream usável dela
		"AudioStreamSynchronized","AudioStreamInteractive","AudioStreamPlaylist":
			reference_stream = _get_child_stream(first_stream)
		# caso não, define reference como a stream, caso n seja formada por varias
		_ when first_stream.is_meta_stream() == false:
			reference_stream = first_stream
		# caso seja formada por varias streams, chama o metodo para pegar primeira stream usável dela
		_ when first_stream.is_meta_stream() == true:
			reference_stream = _get_child_stream(first_stream)
	
	BPM = song_data.BPM                   # pega o BPM dela
	BeatsPerBar = int(reference_stream.get_bar_beats())      # pega as BeatsPerBar dela
	SPB = 60.0 / ( BPM * (BeatsPerBar/4) )                   # calcula SPB
	Clock.wait_time = SPB                                    # Seta o conductor para o tempo certo

# pega a AudioStreamMP3, OggVorbis ou WAV
# usado no _get_bpm()
func _get_child_stream(stream): 
	## Aqui é a mais pura bagunça, desculpa o textão mas puta que pariu.
	## tem um método diferente pra cada uma das 3 AudioStreams Musicais
	## essa função inteira é só lidando com o método de cada uma delas
	
	var count : int # variavel que conta quantas streams tem 
	
	if stream is not AudioStreamInteractive: # se não for interactive, usa a propriedade comum
		count = stream.stream_count # quantos clips tem
	else: # se for, USA A PORRA DA PROPRIEDADE ESPECIFICO PARA INTERACTIVE
		count = stream.clip_count
		
	for i in range(0,count):  # loopa dentro do count
		var audiostream # definimos um audiostream, que pode ser qualquer um
		if stream is AudioStreamSynchronized: # se for sync, usa metodo do sync
			audiostream = stream.get_sync_stream(i)
		elif stream is AudioStreamInteractive:# se for interactive, usa metodo do interactive
			audiostream = stream.get_clip_stream(i)
		elif stream is AudioStreamPlaylist:   # se for playlist, usa metodo do playlist
			audiostream = stream.get_list_stream(i)
		else:
			if log_level <=3 : Logger.warn("audiostream is not meta_stream")
		
		# checa se o resultado n foi um dos tipos de audiostreams formados de outro
		# se for, repete a função
		if (audiostream is AudioStreamInteractive) \
		 or (audiostream is AudioStreamPlaylist) \
		 or (audiostream is AudioStreamSynchronized):
				_get_child_stream(audiostream)
		# se não, só retorna o audiostream
		elif (audiostream is AudioStreamMP3) \
		 or (audiostream is AudioStreamOggVorbis) \
		 or (audiostream is AudioStreamWAV):
			return audiostream
		# se n for nenhum deles, deu merda
		else:
			if log_level <=4 :Logger.error("No Usable AudioStreams found",get_stack())

# literal só pega o tempo atual da engine
func _get_elapsed_time() -> float: return Time.get_ticks_msec()/1000

# função que remove trigger
func _trigger_remove():
	for n in TriggerPlayer.get_children(): # literal só remove e queue_free diretão
		TriggerPlayer.remove_child(n)
		n.queue_free()

# função que cria trigger
func _trigger_populate(triggers:Array): 
	for i in range(0,triggers.size()):    # cria audiostreams pra cada clip de trigger
		var trigger_node = AudioStreamPlayer.new() # cria audiostreamplayer
		trigger_node.set_stream(triggers[i])       # seta a stream dele pro clip de trigger
		trigger_node.volume_db = 1                 # volume pra 1
		trigger_node.pitch_scale = 1               # pitch pra 1
		# ATTENTION TENHO QUE IMPLEMENTAR ISSO DIREITO
		trigger_node.name = triggers[i].resource_path.get_file().get_basename()  # seta o nome do node pro nome do clip
		# ATTENTION TENHO QUE IMPLEMENTAR ISSO DIREITO 
		_trigger_stems.append(trigger_node.name)   # dá append na var das stems
		TriggerPlayer.add_child(trigger_node)      # adiciona o node ao player
	if log_level <=2: 
		Logger.info("Trigger Loaded = "+str(_trigger_stems.size()))
		if _trigger_stems.size() > 0:
			Logger.debug("Loaded Triggers = "+str(_trigger_stems))

# método pra tocar trigger syncado
func _trigger_play(TriggerStem, sync_method:int=0): 
	match sync_method:
		0: ## por beat
			# previsão de quando é a próxima barra
			var next_beat = (_last_beat_time+SPB)
			# o tempo em que vai ser feita a transição
			var switch_time : float = next_beat - snappedf(_get_elapsed_time(),SPB)
			
			if log_level <=1 : # Log pra saber onde vai transicionar
				Logger.debug("last_beat_time ["+str(_last_beat_time)+" s]")
				Logger.debug("next_beat_time ["+str(next_beat)+" s]") 
			
			await get_tree().create_timer(abs(switch_time)).timeout # Espera o switch_time
			
			TriggerStem.play() # da play
			if log_level <=2: Logger.info("playing: "+TriggerStem.name)
		1: ## por bar
			var bar_time: float = SPB*BeatsPerBar  # tempo para uma barra/measure      
			var next_bar = (_last_bar_time+bar_time) # previsão de quando é a próxima barra
			var switch_time : float = next_bar - snappedf(_get_elapsed_time(),SPB)
			# ^ o tempo em que vai ser feita a transição
			
			if log_level <=1 : # Log pra saber onde vai transicionar
				Logger.debug("last_bar_time ["+str(_last_bar_time)+" s]")
				Logger.debug("next_bar_time ["+str(next_bar)+" s]") 
			
			await get_tree().create_timer(abs(switch_time)).timeout # Espera o switch_time
			
			TriggerStem.play() # da play
			if log_level <=2: Logger.info("playing: " + TriggerStem.name)
		_: ## fora da seleção
			if log_level <= 3: Logger.warn("Invalid sync method for playing trigger", get_stack())

# ATTENTION melhorar depois, pq haha o godot n tem NOME PRA RESOURCE
func _get_sync_streams(stream:AudioStreamSynchronized) -> void:
	var count = stream.stream_count
	#var audiostream : Variant
	#for i in range(0,count):
		#audiostream = stream.get_sync_stream(i)
		#var temp_dict : Dictionary = {audiostream.resource_name:i} # ATTENTION Melhorar depois
		#_sync_streams.merge(temp_dict, false)
	if log_level <= 1: Logger.debug("there are" + str(count) + " sync_streams and they are: " +str(_sync_streams))

# _load_mp3() não é usada mais
## cria o _silent_audiostream
func _load_mp3() -> AudioStreamMP3: 
	var file = FileAccess.open(_silence_path, FileAccess.READ)
	# pega um arquivo em silencio
	var sound = AudioStreamMP3.new()
	# cria um AudioStreamMP3 Novo
	sound.data = file.get_buffer(file.get_length())
	# Esqueci
	return sound 
	# retorna a audiostream
