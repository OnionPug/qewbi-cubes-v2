extends Area2D
@export var text : String

signal dialogue_active

func _ready() -> void:
	if text: 
		$CanvasLayer/Label.text = ''
		var textsplit = text.split(":n")
		for i in textsplit:
			$CanvasLayer/Label.text += i + "\n"
	$Fade.speed_scale = randf_range(0.9,1.1)

func _on_body_entered(body: Node2D) -> void:
	$Marker.modulate = Color(1,1,1,0.4)
	$CanvasLayer.set_deferred("visible", true)
	$Fade.play("FadeIn")



func _on_body_exited(body: Node2D) -> void:
	$Marker.modulate = Color(1,1,1,1)
	$Fade.play("FadeOut")
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer.set_deferred("visible", false)
