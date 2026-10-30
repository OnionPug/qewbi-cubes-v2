extends Area2D

@export var key_name : String




func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.get("save_dict"):
		print("has a save")
		if body.save_dict.has("persona"):
			print("has persona")
			body.save_dict["persona"] = true
			queue_free()
	else: 
		print("nope")
