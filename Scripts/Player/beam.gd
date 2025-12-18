extends Area2D

const PART = preload("res://Scenes/Player/beam_part.tscn")
const BEAM = preload("res://Scenes/Player/beam.tscn")
var travel = 0
var speed = 10000
var step = 10
var drawlength
var direction
const MAXTRAVEL = 3000
const TYPE = "normal"

var mp_damage = 1
var hp_damage = 2
	

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	drawlength = speed*delta
	if $RayCast2D.is_colliding():
		var collision_point: Vector2 = $RayCast2D.get_collision_point()
		var collision_normal: Vector2 = $RayCast2D.get_collision_normal()
		print("hit")
		drawlength = (collision_point - position).length()
		queue_free()
		reflect_beam(direction.bounce(collision_normal), collision_point, travel)
	
	for i in range(0, drawlength, step):
		var part = PART.instantiate()
		get_node("/root/Game/Player").add_child(part)
		part.global_position = global_position + (direction*Vector2(i,i))
		part.rotation = rotation
	
	position += direction * speed * delta
	travel += speed * delta
	
	if travel >= MAXTRAVEL: queue_free()
	

func reflect_beam(direction : Vector2, location : Vector2, travel : int):
	var beam = BEAM.instantiate()
	get_node("/root/Game/Player").add_child(beam)
	beam.global_position = location
	beam.direction = direction
	beam.rotation = direction.angle()
	beam.travel += travel

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(0, hp_damage, TYPE)
