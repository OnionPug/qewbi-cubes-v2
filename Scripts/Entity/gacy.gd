extends DialogueMarker


func _ready() -> void:
	
	if text: 
		load_textbox(text[0])
		textlen = len(text)
		if textlen > 1:
			$CanvasLayer/continue.set_deferred("visible", true)

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
		await get_tree().create_timer(0.5).timeout
	load_textbox(text[progress])
	


func enter_animation():
	$CanvasLayer/background.self_modulate = Color(1,1,1,1)
	$CanvasLayer.set_deferred("visible", true)
	$Timer.start(0.7)


func exit_animation():
	$CanvasLayer/background.self_modulate = Color(1,1,1,0.5)
	await $Timer.timeout
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer.set_deferred("visible", false)
