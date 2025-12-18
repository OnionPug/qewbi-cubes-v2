extends State

func enter():
	$"../../Head".play("freeze")
	owner.set_collision_mask_value(12,false)

	
func exit():
	owner.set_collision_mask_value(12,true)
	pass

func physics_update(delta: float):
	var collision = owner.move_and_collide(owner.velocity*delta)
	if collision:
		owner.velocity = owner.velocity.bounce(collision.get_normal())*0.8
	
