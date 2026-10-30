extends State


var collision_count = 0

func enter():
	$"../../Head".play("freeze")
	owner.set_collision_mask_value(12,false)
	owner.velocity *= 1.2

	
func exit():
	owner.set_collision_mask_value(12,true)
	pass

func physics_update(delta: float):
	var collision = owner.move_and_collide(owner.velocity*delta)
	if collision:
		owner.velocity = owner.velocity.bounce(collision.get_normal())*0.8
		collision_count += 1
	if collision_count == 3:
		set_state("normal")
		collision_count = 0

func set_state(state_name):
	if state_name == "melt":
		state_transition.emit(self, "normal")
	else:
		state_transition.emit(self, state_name)
