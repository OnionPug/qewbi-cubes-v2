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

func _physics_process(_delta: float) -> void:
	$Pivot.rotation = $Pivot.global_position.direction_to(get_global_mouse_position()).angle()
