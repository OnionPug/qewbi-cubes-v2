extends Area2D

@export var type : String


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(100, 0, type) # Replace with function body.
