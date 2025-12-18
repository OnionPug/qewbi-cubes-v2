extends Node

#pick a state from the side menu to start as
@export var initial_state : State

var current_state  : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(on_state_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_state_transition(state, new_state_name, exit = true):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		print(new_state_name)
		return
	
	if current_state and exit:
		current_state.exit()
		'for i in range(9,17):
			owner.set_collision_layer_value(i,false)' #precaution code for mask management
	new_state.enter()
	
	current_state = new_state
