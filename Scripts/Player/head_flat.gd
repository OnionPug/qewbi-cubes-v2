extends State

func enter():
	$"../../Head".play("flat")
	owner.set_collision_layer_value(1, false)
	owner.set_collision_layer_value(2, true)
	owner.set_collision_mask_value(10, true)
