extends StaticBody2D

var hit : bool = false
@export var time : float
@export var kill_qewbi : bool

func _ready() -> void:
	$Timer.start(time*0.4)
	$Slam.speed_scale = (1.0/time)
	$Slam.play("PistonSlam")

func _on_timer_timeout() -> void:
	
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	set_collision_layer_value(10, false)
	
	await get_tree().create_timer((time*0.6)-0.05).timeout
	
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
	
	await get_tree().create_timer(0.05).timeout
	
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	set_collision_layer_value(10, true)
	
	$Timer.start(time*0.4)
	$Slam.play("RESET")
	$Slam.play("PistonSlam")
	


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(100, 0, "flat")
		if kill_qewbi:
			time = randf_range(0.05, 0.5)
			$Slam.speed_scale = (1.0/time)
