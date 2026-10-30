extends Node2D



#make signals to connect the world & player to the UI
#move this from ready(): to an activated function once the menu's up and running
#should activate only after Play is pressed
func _ready():
	connect_world()
	$UI.load_game()



func connect_world():
	#take the currently active world - when it exits, connect the next world up to do the same
	$World.get_child(0).tree_exited.connect(connect_world)
	#if nothing exists, end function
	if get_tree() == null:
		return








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
