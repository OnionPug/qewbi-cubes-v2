extends State

@export var speed : int

const HEAD = preload("res://Scenes/Player/player_head.tscn")
var head : Node

var direction : Vector2
var mouse_direction : Vector2

#owner.set_collision_mask_value(13,true)
#owner.get_collision_mask_value(13)

func enter():
	if owner.get_collision_mask_value(13) == true:
		$"../../Head".visible = false
		head = HEAD.instantiate()
		#connect signal from head to a method here to disable headless
		owner.get_parent().add_child(head)
		head.global_position = owner.global_position + Vector2(0,-150)
		head.velocity = Vector2(randf_range(-50,50),-100)
		if get_node_or_null("../../Camera"): 
			$"../../Camera".global_position = head.global_position
			$"../../Camera".reparent(head)
		$HeadlessSound.play()
		owner.set_collision_mask_value(13,false)

func exit():
	if owner.get_collision_mask_value(13) == false:
		$"../../Head".visible = true
		for i in owner.get_parent().get_children():
			if i.name == "PlayerHead":
				i.exit(owner)
			owner.set_collision_mask_value(13,true)



func update(_delta):
	
	#sprite management
	if owner.velocity.length() > 0:
		$"../../Body".play("dizzyrun")
	else: 
		$"../../Body".play("dizzy")
		
	#flip body
	if direction.length() != 0:
		$"../../Body".flip_h = direction.x > 0
	
	

func physics_update(_delta):
	#movement
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	mouse_direction = owner.global_position.direction_to(owner.get_global_mouse_position())
	owner.velocity = direction * speed
	owner.move_and_slide()



func set_state(state_name):
	if state_name == "freeze" or state_name == "melt":
		$"..".states[state_name].can_attack = false
		state_transition.emit(self, state_name, state_name == "normal") 
		#self, next state, run exit command
	else:
		state_transition.emit(self, state_name, state_name == "normal")
