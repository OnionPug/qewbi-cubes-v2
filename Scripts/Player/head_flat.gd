extends State

var direction : Vector2 = Vector2(0,0)
var new_direction : Vector2
var strength : float
var struggle : int = 0
var struggle_threshold = 60
@export var speed : int

func enter():
	$"../../Head".play("flat")
	owner.set_collision_layer_value(1, false)
	owner.set_collision_layer_value(2, true)
	owner.set_collision_mask_value(10, false)

func physics_update(delta: float):
	new_direction = owner.global_position.direction_to(owner.get_global_mouse_position())
	strength = (1-direction.dot(new_direction))*100
	owner.velocity = speed*direction*strength*delta
	owner.move_and_slide()
	struggle += strength
	
	#animation
	if struggle > 0:
		$"../../Head".position = Vector2(randf_range(-5,5),randf_range(-5,5))
	else:
		$"../../Head".position = Vector2(0,0)
		
		
	#escape condition
	if struggle >= struggle_threshold and direction != Vector2(0,0):
		set_state("normal")
		struggle = 0
	struggle -= 15
	
	direction = new_direction
	

func exit():
	owner.set_collision_layer_value(1, true)
	owner.set_collision_layer_value(2, false)
	owner.set_collision_mask_value(10, true)
	pass
