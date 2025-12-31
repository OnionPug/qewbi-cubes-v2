extends Node2D



#make signals to connect the world & player to the UI

#recieve signals from marker - what dialogue to play
#DONT DO THIS, ITS NOT WORTH IT - recieve signals from world - what characters to render
func _ready():
	connect_world()

func play_dialogue():
	pass

func connect_world():
	$World.get_child(0).tree_exited.connect(connect_world)
	if get_tree() == null:
		return
	for area in get_tree().get_nodes_in_group("Dialogue"):
		area.dialogue_active.connect($UI/DialoguePlayer.play_dialogue)
		print(area)







#figure out a way to load new player textures
'func _ready() -> void:
	var exe_path := OS.get_executable_path().get_base_dir()
	print(exe_path+"/Sprites")
	load_external_texture(exe_path+"/Sprites")
	

func load_external_texture(path: String) -> Texture2D:
	if not FileAccess.file_exists(path):
		push_error("File not found: " + path)
		return null

	var image := Image.new()
	var err := image.load(path)
	if err != OK:
		push_error("Failed to load image: " + path)
		return null

	var texture := ImageTexture.create_from_image(image)
	return texture
'
