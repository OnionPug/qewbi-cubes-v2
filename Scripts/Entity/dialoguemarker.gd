extends Area2D
class_name DialogueMarker
@export var text : Array[String] = [""] #body text
@export var check : String #check to see if dialogue tree condition is satisfied

signal dialogue_active

var player : Node2D
var chain : bool = false
var in_area : bool = false
var textlen : int
var progress : int


func _ready() -> void:
	if text: 
		load_textbox(text[0])
		textlen = len(text)
		if textlen > 1:
			$CanvasLayer/continue.set_deferred("visible", true)
	$Fade.speed_scale = randf_range(0.9,1.1)

func load_textbox(textbox):
	$CanvasLayer/Label.text = ''
	var textsplit = textbox.split(":n")
	for i in textsplit:
		$CanvasLayer/Label.text += i + "\n"

func next():
	progress+=1
	if progress >= textlen or progress == 0:
		progress = 0
		_on_body_exited(player)
		await $Timer.timeout
		await get_tree().create_timer(0.2).timeout
	load_textbox(text[progress])
	

func _on_body_entered(body: Node2D) -> void:
	player = body
	in_area = true
	progress = 0
	load_textbox(text[progress])
	enter_animation()

func enter_animation():
	$Marker.modulate = Color(1,1,1,0.4)
	$CanvasLayer/Sprite.process_mode = Node.PROCESS_MODE_INHERIT
	$CanvasLayer.set_deferred("visible", true)
	$Fade.play("FadeIn")
	$Timer.start(0.7)
	pass


func _on_body_exited(body: Node2D) -> void:
	in_area = false
	exit_animation()

func exit_animation():
	$Marker.modulate = Color(1,1,1,1)
	await $Timer.timeout
	$Fade.play("FadeOut")
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer.set_deferred("visible", false)
	$CanvasLayer/Sprite.process_mode = Node.PROCESS_MODE_DISABLED

func _on_background_gui_input(event: InputEvent) -> void:
	if event.is_pressed() == true:
		print("input get")
		next()
	pass # Replace with function body.

func continue_animation():
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("interact") and in_area:
		print("interaction get")
		next()
