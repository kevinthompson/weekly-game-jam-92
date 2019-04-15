extends KinematicBody2D

signal off_screen

const FLOOR = Vector2(0,-1)
var velocity = Vector2()
var jump_direction = 1

export var gravity := 64
export var jump_speed := 200
export var max_fall_speed := 100 
export var move_speed := 64

func _physics_process(delta):
	if get_global_transform_with_canvas().origin.x < (get_viewport().size.x / 2):
		$Sprite.set_flip_h(false)
		jump_direction = 1
	else:
		$Sprite.set_flip_h(true)
		jump_direction = -1
	
	if is_on_floor():
		velocity.y = 0
		velocity.x *= .8
	
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jump_speed
			velocity.x += move_speed * jump_direction
			
	elif is_on_ceiling():
		velocity.y = 0
		
	velocity.y += gravity * delta
	
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	move_and_slide(velocity, FLOOR)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("off_screen")