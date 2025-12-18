extends State

const SPLASH = preload("res://Scenes/Player/splash.tscn")
var speedmult : int = 2
var direction : Vector2
var struggle_power = 1
var struggle_threshold = 200
var struggle = 0


#Sprite - idle is a puddle, moving is a slimegirl. 
#Qewbi collapses into a puddle when not moving, disabling her hitbox.


func enter():
	$"../../Pivot/AimPointer".visible = true
	$"../../Head".play("melt")
	$"../../Body".play("melt")
	$MeltSound.play()

func exit():
	$"../../Pivot/AimPointer".visible = false
	if escalation: deescalate()
	struggle = 0


func escalate():
	escalation = true
	owner.velocity = Vector2(0,0)
	speedmult = 1
	await get_tree().create_timer(5).timeout
	deescalate()

func deescalate():
	escalation = false
	speedmult = 2

	

func physics_update(delta):
	#movement
	if owner.mana == 0:
		return
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	owner.velocity = direction * (owner.mana * speedmult/2) * delta + owner.velocity
	if direction.length() == 0:
		owner.velocity *= 0.8
		if owner.velocity.length() < 0.001:
			owner.velocity = Vector2(0,0)
	elif owner.velocity.length() >= speedmult*owner.mana:
		owner.velocity = (owner.velocity*speedmult*owner.mana)/owner.velocity.length()
	
	owner.move_and_slide()
	
	#flip body
	if direction.length() != 0:
		$"../../Head".flip_h = direction.x > 0
		$"../../Body".flip_h = direction.x > 0
	
	#recovery
	if owner.velocity.length() == 0 and owner.mana >= 100:
		struggle += struggle_power
	else:
		struggle = 0
	
	if struggle > 0: 
		for x in [$"../../Body", $"../../Head"]: x.position = Vector2(randf_range(-struggle*0.01,struggle*0.01),randf_range(-struggle*0.01,struggle*0.01))
	else: 
		for x in [$"../../Body", $"../../Head"]: x.position = Vector2(0,0)
	
	if struggle >= struggle_threshold:
		if owner.get_collision_mask_value(13) == false:
			set_state("headless")
		else:
			set_state("normal")

func fire(input):
		#shooting
	if $"../../Cooldown".time_left == 0 and input:
		$"../../Cooldown".start(0.2)
		if owner.mana > 0:
			attack() #emerald splash!!!
			owner.mana -= 20
	elif not input:
			$"../../Regen".start(0.2)

	
func attack():
	owner.velocity *= 0
	var splash = SPLASH.instantiate()
	splash.global_position = $"../../Pivot/FiringPoint".global_position
	splash.rotation = $"../../Pivot".rotation
	get_node("/root/Game/Player").add_child(splash)
	pass


func set_state(state_name):
	if state_name == "melt":
		escalate()
	elif state_name == "freeze": 
		if owner.get_collision_mask_value(13) == false:
			state_transition.emit(self, "headless")
		else:
			state_transition.emit(self, "normal")
	elif state_name == "dizzy":
		state_transition.emit(self, state_name)
		#dizzy animation for melt
	else:
		state_transition.emit(self, state_name)
