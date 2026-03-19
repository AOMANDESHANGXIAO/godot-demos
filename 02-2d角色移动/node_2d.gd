extends Node2D

var speed = 400
var screen_size
var animation = "walk_down"
var face_to = "left"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size # Replace with function body.
	print("screen_size:",screen_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 输出position
	if Input.is_action_just_pressed("ui_up"):
		print(position)
	
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.y > 0:
		animation = "walk_down"
		face_to = "down"
	elif velocity.y < 0:
		animation = "walk_up"
		face_to = "up"
	elif velocity.x < 0:
		animation = "walk_left"
		face_to = "left"
	elif velocity.x > 0:
		animation = "walk_left"
		face_to = "right"
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.flip_h = face_to == "right"
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
