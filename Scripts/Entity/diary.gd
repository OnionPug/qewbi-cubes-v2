extends Area2D


func _on_body_entered(body: Node2D) -> void:
	$CanvasLayer.set_deferred("visible", true)
	$Fade.play("FadeIn")



func _on_body_exited(body: Node2D) -> void:
	$Fade.play("FadeOut")
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer.set_deferred("visible", false)
