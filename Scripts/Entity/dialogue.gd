extends Area2D
class_name Dialogue

signal dialogue_active

#This shit sucks to code, i'm benching it

#code for the dialogue markers and npcs, to be sent up to the UI
@export var import_dialogue : Array[String]
var dialogue_chain : Array[textbox]
var num: int = 0
class textbox:
	var char_name : String
	var text : String
	var autoplay : bool
	var delay : int
	
	func _init(a:String = "", b:String = "", c:bool = false, d:int = 1) -> void:
		char_name = a
		text = b
		autoplay = c
		delay = d


func _ready():
	for unsplit in import_dialogue:
		var split = unsplit.split(":", true)
		split.resize(4)
		dialogue_chain.append(textbox.new(split[0], split[1], split[2] == "true", split[3].to_int()))
	'for i in dialogue_chain:
		print(i.char_name)
		print(i.text)'
		
