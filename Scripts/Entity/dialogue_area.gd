extends Dialogue
var in_area : bool = false


func _process(_delta: float) -> void:
	if num >= len(dialogue_chain):
		in_area = false
		num = 0
	if in_area and (Input.is_action_just_pressed("interact") or dialogue_chain[num].autoplay):
		print(dialogue_chain[num].char_name)
		print(dialogue_chain[num].text)
		num += 1
		


func _on_body_entered(body: Node2D) -> void:
	in_area = true
	print('entered')
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	in_area = false
	pass # Replace with function body.
