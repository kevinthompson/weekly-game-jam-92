extends Node2D

onready var platform = preload("res://Platform.tscn")

#func _ready():
#	var new_platform = platform.instance()
#	new_platform.position = Vector2(20,30)
#	add_child(new_platform)

func _process(delta):
	var camera = $Player/Camera2D
	var game_height = get_viewport().size.y
	var camera_position = camera.get_camera_position()
	var new_limit_bottom = (game_height / 2) + camera_position.y
	
	if camera.limit_bottom > new_limit_bottom:
		camera.limit_bottom = new_limit_bottom
		
	$Walls.position.y = camera_position.y - game_height / 2
	
	$TileMap.set_cellv(Vector2(-1,0), 1)

func _on_Player_off_screen():
	print("Game Over")