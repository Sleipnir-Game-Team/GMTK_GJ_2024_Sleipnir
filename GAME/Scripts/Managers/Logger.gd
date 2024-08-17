## Logging 
##
## AutoLoad para logging da sleipnir

extends Node

# Ativa ou desativa logging
# TODO não esquecer
# enum log_level:{all,debug,info,warn,error,fatal,off}


func _init():
	pass

## Indicação sobre algo acontecendo.[br]
## Por exemplo, se algo entrou ou saiu da cena, se algum recurso foi criado, não algo muito profundo
func info(message: String) -> void: 
	print_rich("[color=cyan]INFO: [/color][color=blue]",message,"[/color]")


## Diagnóstico geral.[br]
## Por exemplo, se uma variável mudou de estado, se uma função foi chamada, com bastante detalhe geralmente
func debug(message: String) -> void: 
	print_rich("[color=green]DEBUG: [/color][color=gray]",message,"[/color]")


## Indicação de risco em potêncial.[br]
## Por exemplo, uma variável assumiu um valor que não devia, falta de algum recurso que pode levar a erro[br]
## Não requer um [code]get_stack()[/code] ao ser chamado, porém pode ser usado.[br]
## [codeblock]
## Logger.warn("messagem", get_stack())
## #ou
## Logger.warn("mensagem")
## [/codeblock]
func warn(message: String, back_trace: Array = []) -> void:
	if back_trace == []:
		push_warning(message)
	else:
		var where_went_wrong : String
		for stack in back_trace:
			where_went_wrong = where_went_wrong + stack["source"] + ": line " + str(stack["line"]) \
			+  " in function " + stack["function"] + "\n"
		
		push_warning(message,"\n check: \n", where_went_wrong)


## Indicação de um problema que deve ser resolvido, mas não "irei crashar" nível de sério.[br]
## Por exemplo, uma função que cuida da AI dos inimigos do nada jogando eles pra fora do mapa[br]
## requer um [code]get_stack()[/code] ao ser chamado.[br]
## [codeblock]
## Logger.error("mensagem", get_stack())
## [/codeblock]
func error(message: String, back_trace: Array[Dictionary]) -> void:
	var where_went_wrong : String
	for stack in back_trace:
		where_went_wrong = where_went_wrong + stack["source"] + ": line " + str(stack["line"]) \
		+  " in function " + stack["function"] + "\n"
	
	push_error(message,"\n try checking: \n", where_went_wrong)


## Indicação de que deu um problema que para o programa, erro irrecuperavel.[br]
## Por exemplo, uma coisa que não devia dar errado de jeito nenhum dando errado[br]
## requer um [code]get_stack()[/code] ao ser chamado.[br]
## [codeblock]
## Logger.fatal("mensagem", get_stack())
## [/codeblock]
func fatal(message: String, back_trace: Array[Dictionary]) -> void:
	var where_went_wrong : String
	for stack in back_trace:
		where_went_wrong = where_went_wrong + stack["source"] + ": line " + str(stack["line"]) \
		+  " in function " + stack["function"] + "\n"
	
	print_rich("[bgcolor=red][color=black]FATAL:[/color][/bgcolor] [color=red]",message,"\n located at: \n",
	 where_went_wrong,"[/color]")


## @experimental
## Cria o arquivo de log com tudo dentro
func create_log_file(): # TODO
	pass
