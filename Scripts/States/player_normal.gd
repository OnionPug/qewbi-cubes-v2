extends State

const BULLET = preload("res://Scenes/Player/bullet.tscn")
@export var speed : int

var direction : Vector2
var mouse_direction : Vector2

func enter():
	#gameplay
	owner.set_collision_mask_value(9,false)
	#visual
	$"../../Head".play("idle")
	$"../../Body".play("idle")
	$"../../Pivot/AimPointer".visible = true
	#debug setting
	$"../Headless".exit()

func exit():
	owner.set_collision_mask_value(9,true)
	$"../../Head".flip_h = false
	$"../../Body".flip_h = false
	$"../../Pivot/AimPointer".visible = false

func update(_delta):
	
	#sprite management
	if owner.velocity.length() > 0:
		$"../../Head".play("run")
		$"../../Body".play("run")
	else: 
		$"../../Head".play("idle")
		$"../../Body".play("idle")
	
	#flip body
	if direction.length() != 0:
		$"../../Body".flip_h = direction.x > 0
	#flip head
	$"../../Head".flip_h = mouse_direction.x > 0

func physics_update(delta):
	#movement
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	mouse_direction = Vector2.RIGHT.rotated(($"../../Pivot".rotation))
	owner.velocity = direction * speed * delta
	owner.move_and_slide()
	
	
	
	#shooting
	if $"../../Cooldown".time_left == 0 and Input.is_action_pressed("mouse1"):
		$"../../Cooldown".start(0.5)
		if owner.mana > 0:
			attack()
			owner.mana -= 10
	elif Input.is_action_just_released("mouse1"):
			$"../../Regen".start(1)
	
	

func attack():
	var bullet = BULLET.instantiate()
	bullet.global_position = $"../../Pivot/FiringPoint".global_position
	bullet.rotation = $"../../Pivot".rotation
	get_node("/root/Game/Player").add_child(bullet)
