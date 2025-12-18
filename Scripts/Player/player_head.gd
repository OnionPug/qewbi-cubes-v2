extends CharacterBody2D

func take_damage(_mp_damage, _hp_damage, type = "normal"):
	if type != "headless":
		$"State Machine".current_state.set_state(type)

func exit(body) -> void:
	if get_node_or_null("Camera"): 
		$"Camera".global_position = body.global_position + Vector2(0,-80)
		$"Camera".reparent(body)
	queue_free()
