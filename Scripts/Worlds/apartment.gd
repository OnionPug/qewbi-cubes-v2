extends Node2D

func _ready() -> void:
	for x in [$Bossfight/FlatGate2, $Bossfight/Info9]:
		toggle(x,false)
	pass


func create_entity(name):
	pass


func _on_entry_body_entered(body: Node2D) -> void:
	$Bossfight/Entry.queue_free()
	for x in [$Bossfight/Info8,$Bossfight/Entry]:
		toggle(x, false)
	toggle($Bossfight/FlatGate2,true)
	await get_tree().create_timer(1).timeout
	toggle($Bossfight/Info9,true)
	await get_tree().create_timer(3).timeout
	toggle($Bossfight/Info9, false)
	
	
func toggle(node : Node2D, mode : bool):
	if mode:
		node.set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		node.set_process_mode(Node.PROCESS_MODE_DISABLED)
	node.visible = mode


func _on_cube_death() -> void:
	#move persona to bossfight death
	if $Bossfight/Persona:
		$Bossfight/Persona.position = $Bossfight/Cube.position
	toggle($Bossfight/FlatGate2, false)
	
