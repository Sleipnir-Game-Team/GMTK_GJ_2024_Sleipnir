@tool
extends Node
## (singleton) Sound Effects que podem levar trigger de qualquer lugar do projeto
##
## Utilize esta cena para sons que irão se repetir em multiplos lugares pelo jogo
## como botões de UI, ataques em comum de inimigos, e etc.


var child_nodes : Array[SoundQueue] ## Lista de AudioStreamPlayer's Globais
var child_search: Array[String] ## Lista dos nomes de cada AudioStreamPlayer, para busca mais facil

func get_all(node:Node): ## Método para pegar todos as children e grand children de um node
	var all_child : Array[SoundQueue]
	for child in node.get_children():
		if child is SoundQueue:
			all_child.append(child)
			child_search.append(child.name)
		for grand_child in get_all(child):
			if grand_child is SoundQueue:
				all_child.append(grand_child)
	return all_child

func _ready():
	child_nodes.clear()
	child_search.clear()
	child_nodes = get_all(self)

func play_global(sfx_name: String): ## Método para tocar um SFX Global
	#print_rich("[color=tomato][SFXGlobals](sent)[/color] ",child_nodes[child_search.find(sfx_name)])
	AudioManager.play_sfx(child_nodes[child_search.find(sfx_name)], 4)
