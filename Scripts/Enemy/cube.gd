extends CharacterBody2D

var mp_damage = 100
var hp_damage = 1
var type = "flat"
@export var speed = 15
@export var health = 3

var player
var aggro : bool
var bodyStateMachine
var direction = Vector2(0,0)
var a = Vector2(0,0)
var accel = false:
	set(value):
		if value != accel:
			if value:
				mp_damage = 100
				await get_tree().create_timer(0.5).timeout
			else:
				mp_damage = 0
			accel = value



func _physics_process(delta: float) -> void:
	if player != null:
		aggro = bodyStateMachine.current_state != bodyStateMachine.states["flat"]
		if aggro and health > 0:
			direction = self.global_position.direction_to(player.global_position)
		else:
			velocity = a*0.95
	a = velocity
	
	if accel == true:
		velocity = direction * delta * speed + a
	else:
		velocity = a*0.90
	
	accel = (velocity.length()-a.length()) >= -0.05
	
	
	var collision_info = move_and_collide(velocity)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		accel = false
	
	$StoneSound.volume_linear = velocity.length()*0.01
	


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(mp_damage, hp_damage, type)


func _on_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		await get_tree().create_timer(1).timeout
		player = body
		for child in body.get_children():
			if child.name == "State Machine":
				bodyStateMachine = child
				break

				

func take_damage(_mp_damage, hp_damage, _type):
	health -= hp_damage
	velocity *= 0.5
	if health <= 0:
		var world = get_node("/root/Game/World").get_child(0)
		if "enemies" in world:
			world.enemies -= 1
		await get_tree().create_timer(3).timeout
		queue_free()
		#signal to the world that it died


func _on_stone_sound_finished() -> void:
	$StoneSound.play()
	
