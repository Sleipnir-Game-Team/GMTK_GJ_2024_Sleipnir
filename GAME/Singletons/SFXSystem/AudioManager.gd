extends Node
## Gerenciador de Audio da Sleipnir (Singleton)
##
## Cuida de Tocar SFX e Música, além de garantir perfomance
## por meio de limitar número máximo de audio tocando.
## [br] Descomentar os prints caso queira logging no console

var max_audiostreams : int = 256 ## Número Máximo de Sons a tocar
var music_reserve : int ## @experimental espaços reservados para música
var sfx_playing : int   ## Número de sons tocando
var currently_playing_audiostreams : Array ## Lista de AudioStreamPlayers tocando no momento

func _ready():
	currently_playing_audiostreams.clear() 
	# Clear dado, devido ao warning do play_sfx a lista pode acabar fechando com coisa guardada

func play_sfx(audio, _max_poly: int = 4):  ## Método pra tocar SFX, acontando com os limites do AudioManager 
	if audio is Array[Node]: # permite tocar grupos, pq eles são array de nodes
		for member in audio:
			check_play(member)
		return
	if audio is SoundQueue or SoundQueue2D or AudioStreamPlayer or AudioStreamPlayer2D: # se for 
		check_play(audio)
		return
	else: # se n for nenhum dos acima vai dar erro
		push_error(audio ," Not SoundQueue or AudioStreamPlayer")

func check_play(audio,_max_poly: int = 4):    ## O que realmente toca o sfx
	if currently_playing_audiostreams.size() <= max_audiostreams:
		# se o numero de sons tocando for menor ou igual ao numero de audiostreams maxima
		# print_rich("[color=blue][AudioManager](received)[/color] ",audio) ## TODO LOGGING
		if audio is SoundQueue or audio is SoundQueue2D: # tocar o som
			audio.play_sound()                                
		if audio is AudioStreamPlayer or audio is AudioStreamPlayer2D: # tocar o som
			audio.play()
		#print_rich("[b]Tocando:[/b]\n",currently_playing_audiostreams, "\n - - - - - - -") ## TODO LOGGING
		
	if currently_playing_audiostreams.size() > max_audiostreams:
		# se o numero de sons tocando for mais que o numero de audiostreams maxima
		push_warning("Number of AudioStreamPlayers playing at the same time passed the maximum of ", max_audiostreams)
		# puxa esse waning
		currently_playing_audiostreams[0].stop()    # NOTE Godot 4.3 esse metodo vai mudar
		currently_playing_audiostreams.remove_at(0) # NOTE 
		if audio is SoundQueue or SoundQueue2D: # tocar o som
			audio.play_sound()                                
		if audio is AudioStreamPlayer or AudioStreamPlayer2D:
			audio.play()
