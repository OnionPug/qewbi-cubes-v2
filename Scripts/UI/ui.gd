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
	$Menu/PanelContainer/VBoxContainer/Resume.pressed.connect(resume_button)
	$Menu/PanelContainer/VBoxContainer/Settings.pressed.connect(settings_menu)
	$Menu/PanelContainer/VBoxContainer/Debug.pressed.connect(debug_menu)
	$Menu/PanelContainer/VBoxContainer/Quit.pressed.connect(quit_button)
	$Menu/PanelContainer/VBoxContainer/Load.pressed.connect(load_game)
	
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

func resume_button():
	$Menu.visible = not visible


func settings_menu():
	$Settings.visible = not $Settings.visible
	pass


func debug_menu():
	$Debug.visible = not $Debug.visible
	pass

func set_state(state):
	$"../Player/Player/State Machine".current_state.set_state(state)


func load_game():
	#respawn player at apartment, reload through all the bullshit stuff
	if !FileAccess.file_exists("user://savegame.save"):
		#if there's no save to load
		print("No save to load!")
		return
	else:
		print("loaded save!")
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var player = $"../Player/Player"
	var json_string = save_file.get_line()
	var json = JSON.new()
	var save_data = json.parse_string(json_string)
	if save_data is Dictionary:
		player.save_dict = save_data
	else:
		print("load error")
		print(save_data)
	pass

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var player = $"../Player/Player"
	if !player.has_method("save"):
		#if i didn't code it in, then it doesn't break open
		return
	var save_data = player.call("save")
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)
	pass

func quit_button():
	save_game()
	get_tree().quit()
