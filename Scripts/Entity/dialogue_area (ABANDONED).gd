extends Area2D

#Abandoned Version!!!

signal play_dialogue
signal exit_dialogue
var in_area : bool = false

#code for the dialogue markers and npcs, to be sent up to the UI
@export var import_dialogue : Array[String]
var dialogue_chain : Array[textbox]
var num: int = 0
var advance : bool = false
class textbox:
	var char_name : String
	var text : String
	var autoplay : bool
	var delay : float
	
	func _init(a:String = "", b:String = "", c:bool = false, d:float = 1) -> void:
		char_name = a
		text = b
		autoplay = c
		delay = d


func _ready():
	for unsplit in import_dialogue:
		var split = unsplit.split(":", true)
		split.resize(4)
		dialogue_chain.append(textbox.new(split[0], split[1], split[2] == "true", split[3].to_float()))
	#blank dialogue screen to get killed on in the process
	dialogue_chain.append(textbox.new("","",false,1))

func _process(_delta: float) -> void:
	#deeply fucking inefficient code, but needs must
	if num >= len(dialogue_chain):
		in_area = false
		num = 0
		emit_signal("exit_dialogue")
	else:
		advance = (Input.is_action_just_pressed("interact") or dialogue_chain[num].autoplay) or (num != 0 and Input.is_action_just_pressed("mouse1"))
	if in_area:
		if advance:
			emit_signal("play_dialogue",dialogue_chain[num].char_name,dialogue_chain[num].text)
			print(dialogue_chain[num].char_name)
			print(dialogue_chain[num].text)
			num += 1
		


func _on_body_entered(body: Node2D) -> void:
	in_area = true
	print('entered')
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	in_area = false
	num = 0
	pass # Replace with function body.
