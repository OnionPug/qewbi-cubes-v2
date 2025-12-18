extends CharacterBody2D

var health = 5:
	set(value):
		if value < 0:
			value = 0
		health = value
var mana = 100: # bar used to tank hits and to cast magic
	set(value):
		if value < 0:
			value = 0
		elif value > 100:
			value = 100
		mana = value


var mouse_input : bool:
	set(value):
		mouse_input = value
		if not mouse_input:
			$"State Machine".current_state.fire(false)
var can_attack : bool = true:
	set(value):
		can_attack = value
		if not can_attack:
			mouse_input = false


func take_damage(mp_damage, hp_damage, type = "normal"):
	mana -= mp_damage
	$Regen.start(1)
	if mana == 0:
		$"State Machine".current_state.set_state(type)
		health -= hp_damage
		if health == 0:
			$"State Machine".current_state.set_state("dizzy")

func _process(_delta: float) -> void:
	#regeneration
	if $Regen.time_left == 0 and $Cooldown.time_left == 0 and mana < 100:
		$Regen.start(0.05)
		mana += 2.5
		
	if mouse_input and can_attack:
		$"State Machine".current_state.fire(true)

		

func _physics_process(_delta: float) -> void:
	$Pivot.rotation = $Pivot.global_position.direction_to(get_global_mouse_position()).angle()



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		mouse_input = true
	elif event.is_action_released("mouse1"):
		mouse_input = false
		
	
		
