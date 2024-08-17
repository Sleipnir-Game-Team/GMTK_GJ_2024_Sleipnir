extends Node

var oldScreen

func displayScreen(screen):
	return load(screen)
	

func openScreen(screen, parent):
	oldScreen = screen
	screen = screen.instantiate()
	parent.add_child(screen)
	

func freeScreen():
	if oldScreen != null:
		oldScreen.call_deferred("free")
	else:
		Logger.fatal("Não há cena para liberar", get_stack())
	
