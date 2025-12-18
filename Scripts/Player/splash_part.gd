extends Area2D


var travel = 0
var speed = 150 + randf_range(-20,20)
const MAXTRAVEL = 200
const TYPE = "normal"

var mp_damage = 1
var hp_damage = 0.2

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * speed * delta
	travel += speed * delta
	if travel >= MAXTRAVEL:queue_free()

func _on_body_entered(body) -> void:
	if body.has_method("take_damage"):
		body.take_damage(0, hp_damage, TYPE)
	else:
		queue_free()
