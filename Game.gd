extends Node2D

func _process(delta):
	var camera = $Player/Camera2D
	var game_height = get_viewport().size.y
	var camera_position = camera.get_camera_position()
	var new_limit_bottom = (game_height / 2) + camera_position.y
	
	if camera.limit_bottom > new_limit_bottom:
		camera.limit_bottom = new_limit_bottom
		
	$Walls.position.y = camera_position.y - game_height / 2