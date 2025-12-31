extends CanvasLayer

var debug_inputs = {
	"ui_1": "normal",
	"ui_2": "flat",
	"ui_3": "headless",
	"ui_4": "freeze",
	"ui_5": "melt",
	"ui_0": "dizzy",
}

	
func _ready():
	$Menu/PanelContainer/VBoxContainer/Settings.pressed.connect(settings_menu)
	$Menu/PanelContainer/VBoxContainer/Debug.pressed.connect(debug_menu)
	
	$Debug/PanelContainer/HBoxContainer/Normal.pressed.connect(set_state.bind("normal"))
	$Debug/PanelContainer/HBoxContainer/Flat.pressed.connect(set_state.bind("flat"))
	$Debug/PanelContainer/HBoxContainer/Headless.pressed.connect(set_state.bind("headless"))
	$Debug/PanelContainer/HBoxContainer/Freeze.pressed.connect(set_state.bind("freeze"))
	$Debug/PanelContainer/HBoxContainer/Melt.pressed.connect(set_state.bind("melt"))
	$Debug/PanelContainer/HBoxContainer/Dizzy.pressed.connect(set_state.bind("dizzy"))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if $Menu.visible:
			$Settings.visible = false
			$Debug.visible = false
		$Menu.visible = not $Menu.visible
	
	if Input.is_action_just_pressed("ui_plus"):
		$"../Player/Player/Camera".zoom += Vector2(0.2,0.2)
	
	if Input.is_action_just_pressed("ui_minus"):
		$"../Player/Player/Camera".zoom -= Vector2(0.2,0.2)
	
	if $Debug.visible:
		for i in debug_inputs.keys():
			if Input.is_action_just_pressed(i):
				set_state(debug_inputs[i])
	
	

func settings_menu():
	$Settings.visible = not $Settings.visible
	pass

func debug_menu():
	$Debug.visible = not $Debug.visible
	pass

func set_state(state):
	$"../Player/Player/State Machine".current_state.set_state(state)
