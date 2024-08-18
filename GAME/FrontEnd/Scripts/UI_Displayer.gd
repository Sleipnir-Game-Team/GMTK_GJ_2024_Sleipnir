extends Node

var oldScreen

func displayScreen(screen):
	screen = load(screen)
	return screen
	

func openScreen(screen, parent):
	screen = screen.instantiate()
	oldScreen = screen
	parent.add_child(screen)
	

func freeScreen():
	if oldScreen != null:
		oldScreen.call_deferred("free")
	else:
		Logger.fatal("Não há cena para liberar", get_stack())
	
