extends CenterContainer

func _on_resume_pressed() -> void:
	visible = not visible

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
