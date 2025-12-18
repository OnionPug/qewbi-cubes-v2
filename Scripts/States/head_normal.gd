extends State
@export var speed : int
var direction : Vector2
var mouse_direction : Vector2

func enter():
	$"../../Area2D".set_collision_mask_value(1, false)
	$"../../Head".play("dizzy")
	await get_tree().create_timer(1).timeout
	$"../../Area2D".set_collision_mask_value(1, true)
	pass

func exit():
	#if escalation: deescalate()
	owner.rotation = 0
	$"../../Area2D".set_collision_mask_value(1, false)


func update(delta: float):
	owner.rotation += delta*owner.velocity.x*0.015 + owner.velocity.y*0.0001
	pass

func physics_update(delta: float):
	direction = owner.global_position.direction_to(owner.get_global_mouse_position())
	var a = owner.velocity
	owner.velocity = speed*direction*delta + a
	owner.move_and_slide()
	pass

func set_state(state_name):
	#base code - only works if this function is not declared elsewhere
	state_transition.emit(self, state_name)

func escalate():
	#make the debuff worse
	#escalation = true
	pass

func deescalate():
	#revert the debuff
	#escalation = false
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyStateMachine
	for child in body.get_children():
		if child.name == "State Machine":
			bodyStateMachine = child
			break
	#head can only be collected if no other status conditions have been applied
	if body.name == "Player" and bodyStateMachine.current_state == bodyStateMachine.states["headless"]:
		owner.queue_free()
		bodyStateMachine.on_state_transition(bodyStateMachine.states["headless"], "normal", true)
		if get_node_or_null("../../Camera"): 
			$"../../Camera".global_position = body.global_position
			$"../../Camera".reparent(body)
