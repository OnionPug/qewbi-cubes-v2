extends Node2D


func _ready() -> void:
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
