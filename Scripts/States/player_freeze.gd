extends State

const BEAM = preload("res://Scenes/Player/beam.tscn")
var knockback = 250
var struggle_power = 10
var struggle_threshold = 100
var struggle_cost = 10
var attack_cost = 40
var struggle = 0:
	set(value):
		struggle = value
		if struggle < 0:
			struggle = 0


func enter():
	$"../../Pivot/AimPointer".visible = true
	owner.regen_rate = 10
	$"../../Head".play("freeze")
	$"../../Body".play("freeze")
	$FreezeSound.play()

func exit():
	$"../../Pivot/AimPointer".visible = false
	owner.regen_rate = 2.5
	struggle = 0
	if escalation: deescalate()

func escalate():
	escalation = true
	#owner.velocity = Vector2(0,0)
	#$"../../Head".play("frozen2")
	#$"../../Body".play("frozen2")
	knockback = 0

func deescalate():
	escalation = false
	knockback = 250

func physics_update(_delta):
	#movement
	
	owner.move_and_slide()
	
	for x in ["move_left","move_right","move_up","move_down"]:
		if Input.is_action_just_pressed(x) == true and $"../../Cooldown".time_left == 0 and owner.mana >= struggle_cost:
			struggle += struggle_power
			owner.mana -= struggle_cost
			$"../../Cooldown".start(0.2)
			$"../../Regen".start(1)
	if struggle > 0: 
		for x in [$"../../Body", $"../../Head"]: x.position = Vector2(randf_range(-struggle*0.01,struggle*0.01),randf_range(-struggle*0.01,struggle*0.01))
	else: 
		for x in [$"../../Body", $"../../Head"]: x.position = Vector2(0,0)
	
	if escalation:
		owner.velocity *= 0.99
	
	if struggle >= struggle_threshold:
		if owner.get_collision_mask_value(13) == false:
			set_state("headless")
		else:
			set_state("normal")

#give Freeze a sniper weapon with high knockback
#schmoovement, baybee

func fire(input):
	if $"../../Cooldown".time_left == 0 and input:
		$"../../Cooldown".start(1.5)
		if owner.mana > 0:
			attack() #beam attack!!!!!
			owner.mana -= attack_cost
			struggle -= struggle_cost*2
	elif not input:
			$"../../Regen".start(0.2)

func attack():
	owner.velocity = Vector2(-1, 0).rotated($"../../Pivot".rotation) * knockback
	var beam = BEAM.instantiate()
	beam.global_position = $"../../Pivot/FiringPoint".global_position
	beam.rotation = $"../../Pivot".rotation
	get_node("/root/Game/Player").add_child(beam)

func set_state(state_name):
	if state_name == "freeze":
		escalate()
	elif state_name == "melt":
		if owner.get_collision_mask_value(13) == false:
			state_transition.emit(self, "headless")
		else:
			state_transition.emit(self, "normal")
	elif state_name == "dizzy":
		$"../../Head".play("dizzy_freeze")
		state_transition.emit(self, state_name)
	else: 
		state_transition.emit(self, state_name)
