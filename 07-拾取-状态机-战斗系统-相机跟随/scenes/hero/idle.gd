class_name Idle
extends State

# Godot 4 默认重力加速度（方便计算）
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter() -> void:
	# 在进入空闲状态时，确保移动速度为0
	actor.velocity.x = 0
	# 播放 Idle 动画 (假设 actor 有一个 AnimationPlayer 节点)
	anim_sprite.play("Idle")

func physics_update(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	# 1. 如果有移动输入，转换到 walk 状态
	if direction != 0:
		transitioned.emit(name, "Walk")
		return
		
	# 2. 如果有跳跃输入，转换到 Jump 状态
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(name, "Jump")
		return
	# 3. 攻击
	if Input.is_action_just_pressed("attack"):
		transitioned.emit(name,"Attack")
		return  
	# 3. 在 Idle 状态下保持重力和移动
	# 仅施加重力（如果角色站在一个活动的平台上，或者检测到不再贴地）
	set_gravity_impact(delta)
	actor.move_and_slide()
