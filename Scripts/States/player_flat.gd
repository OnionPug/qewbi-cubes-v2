extends State

var speed = 75
var struggle_power = 40
var struggle_threshold = 60
var mana_cost = 5
var struggle = 0:
	set(value):
		struggle = value
		if struggle < 0:
			struggle = 0
var struggle_speed = 0:
	set(value):
		struggle_speed = value
		if struggle_speed < 0:
			struggle_speed = 0

func enter():
	owner.set_collision_mask_value(10,false)
	for x in [$"../../Body", $"../../Head"]: 
		x.z_index = -1
		x.offset += Vector2(0, 70)
	owner.regen_rate = 1
	$"../../Head".play("flat")
	$"../../Body".play("flat")
	$FlatSound.play()

func exit():
	owner.set_collision_mask_value(10,true)
	owner.regen_rate = 2.5
	if escalation: deescalate()
	struggle = 0
	struggle_speed = 0
	for x in [$"../../Body", $"../../Head"]: 
		x.z_index = 0
		x.offset = Vector2(0,-325)

func update(_delta):
	#animation
	if struggle > 0 or owner.velocity.length() > 0: 
		for x in [$"../../Body", $"../../Head"]: x.position = Vector2(randf_range(-1,1),randf_range(-1,1))
	else: 
		for x in [$"../../Body", $"../../Head"]: x.position = Vector2(0,0)

func physics_update(_delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	owner.velocity = direction * speed * (struggle_speed*0.1)
	owner.move_and_slide()
	
	for x in ["move_left","move_right","move_up","move_down"]:
		if Input.is_action_just_pressed(x) == true and owner.mana >= mana_cost:
			if $"../../Cooldown".time_left == 0:
				struggle += struggle_power
				struggle_speed += struggle_power
				owner.mana -= mana_cost
				$"../../Cooldown".start(0.2)
				
	print(struggle)
	
	#escape condition
	if struggle >= struggle_threshold:
		if owner.get_collision_mask_value(13) == false:
			set_state("headless")
		else:
			set_state("normal")
	
	struggle -= 2
	struggle_speed -= 5

func escalate():
	escalation = true
	#gameplay
	speed *= 0.5
	struggle_threshold = 80
	#visual
	$"../../Body".scale *= Vector2(1.05,1.05)
	$"../../Head".scale *= Vector2(1.02,1.02)
	for x in [$"../../Body", $"../../Head"]: 
		x.modulate *= Color(1,1,1,0.9)
		x.offset += Vector2(0,4)
	#audio
	$FlatSound.pitch_scale *= 0.9
	$FlatSound.volume_db -= 5
	$FlatSound.play()

func deescalate():
	escalation = false
	#gameplay
	speed = 75
	struggle_threshold = 100
	#visual
	for x in [$"../../Body", $"../../Head"]: 
		x.scale = Vector2(0.35,0.35)
		x.modulate = Color(1,1,1,1)
	#audio
	$FlatSound.pitch_scale = 1
	$FlatSound.volume_db = 0



func set_state(state_name):
	if state_name == "flat":
		escalate()
	elif state_name == "dizzy":
		state_transition.emit(self, state_name, false)
		$"../../Head".play("dizzy_flat")
	else:
		state_transition.emit(self, state_name)
