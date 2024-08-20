extends Node

var screens = []

func displayScreen(screen):
	screen = load(screen)
	return screen
	

func openScreen(screen, parent):
	screen = screen.instantiate()
	screens.append(screen)
	parent.add_child(screen)
	

func freeScreen():
	if screens.size() > 0:
		screens.pop_back().call_deferred("free")
	else:
		Logger.fatal("Não há cena para liberar", get_stack())
	print("\n", screens, "\n")

func syncSouls(label):
	label.text = str(Globals.souls)
	Globals.souls_changed.connect(on_souls_changed.bind(label))

func on_souls_changed(souls, label):
	label.text = str(souls)
	
