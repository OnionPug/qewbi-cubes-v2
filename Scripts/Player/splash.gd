extends Node2D

const PART = preload("res://Scenes/Player/splash_part.tscn")
const TYPE = "normal"

var mp_damage = 1
var hp_damage = 0.5
var bulletcount = 0

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	#fire a shotgun spread of splash_parts, then delete self
	if bulletcount < 5:
		var part = PART.instantiate()
		get_node("/root/Game/Player").add_child(part)
		part.global_position = global_position
		part.rotation = rotation + randf_range(-0.8,0.8)
		bulletcount += 1
	
	
