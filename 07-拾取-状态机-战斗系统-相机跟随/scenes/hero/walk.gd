class_name Walk
extends State

@export var speed = 400

func enter() -> void:
	# 播放 Walk 动画 (假设 actor 有一个 AnimationPlayer 节点)
	anim_sprite.play("Walk")

func physics_update(_delta: float) -> void:
	set_gravity_impact(_delta)
	# 处理x轴向的移动
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		actor.velocity.x = direction * speed
		anim_sprite.flip_h = direction == -1
	else:
		# 不移动的时候切换到闲置
		actor.velocity.x = move_toward(actor.velocity.x,0,speed)
		transitioned.emit("Walk","Idle")
		return
	# 跑步时也可以切换跳跃
	if Input.is_action_just_pressed("jump"):
		transitioned.emit("Walk","Jump")
		return
	if Input.is_action_just_pressed("attack"):
		transitioned.emit("Walk","Attack")
		return
	actor.move_and_slide()
