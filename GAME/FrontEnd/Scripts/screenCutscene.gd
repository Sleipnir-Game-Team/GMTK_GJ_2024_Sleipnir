extends Control

var introText = "type|img;url|res://Assets/Cutscene/Intro 1.jpg\ntype|txt;text|Every day adventurers raid and loot poor dungeons in search of treasure.\ntype|wait\ntype|img;url|res://Assets/Cutscene/Intro 2.jpg\ntype|txt;text|In search of the greatest known treasure, the Dungeon's Heart, the blasted adventurers decided to invade the magnificent living dungeon.\ntype|wait\ntype|img;url|res://Assets/Cutscene/Intro 3.jpg\ntype|txt;text|But what they didn't know is that the dungeon itself could grow.\ntype|wait\ntype|img;url|res://Assets/Cutscene/Intro 4.jpg\ntype|txt;text|Filling the path with traps to stop them\ntype|wait\ntype|img;url|res://Assets/Cutscene/Intro 2.jpg\ntype|txt;text|They think it will be easy to rob me\ntype|wait\ntype|img;url|res://Assets/Cutscene/Intro 5.jpg\ntype|txt;text|F O O L S ! !\ntype|wait\ntype|end"
var actions = []

func _ready():
	UI_Controller.cutsceneNext.connect(on_cutsceneNext)
	UI_Controller.updateCutsceneImg.connect(updateCutsceneImg)
	UI_Controller.updateCutsceneTxt.connect(updateCutsceneTxt)
	for linha in introText.split("\n"):
		var linhaDividida = linha.split(";")
		var actionDict = {}
		for item in linhaDividida:
			var itemDividido = item.split("|")
			actionDict[itemDividido[0]] = itemDividido[1]
		actions.append(actionDict)
	UI_Controller.startCutscene()
	

func on_cutsceneNext():
	UI_Controller.processAction(actions.pop_front())
	

func updateCutsceneImg(image):
	$TextureRect.texture = load(image)
	

func updateCutsceneTxt(text):
	$Label.set_text(text)
	

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		if event.is_pressed():
			UI_Controller.cutsceneNext.emit()
