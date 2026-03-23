extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var is_jumping = false
var is_hurting = false

# 替换原有play_animation函数
@onready var animated_sprite = $AnimatedSprite2D  # 获取AnimatedSprite2D节点
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hit_audio_player: AudioStreamPlayer2D = $HitAudioPlayer

func _physics_process(delta: float) -> void:
	

	# 1. 重力逻辑（原有）
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_hurting:
		play_animation("hit")
		return
	# 2. 跳跃逻辑（原有）
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		audio_stream_player_2d.play()

	# 3. 移动逻辑（原有）
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. 执行移动（原有）
	move_and_slide()

	# ---------------------- 新增：动画切换核心逻辑 ----------------------
	update_animation(direction)
		# 如果正在受伤，播放受伤动画


func play_animation(anim_name: String) -> void:
	if animated_sprite.animation != anim_name:
		animated_sprite.animation = anim_name
		# 闲置/奔跑动画循环，跳跃动画单次播放
		animated_sprite.play()

# 新增：专门处理动画切换的函数（解耦，代码更清晰）
func update_animation(direction: float) -> void:
	# 优先判断跳跃状态（空中时无论是否移动，都播放jump动画）
	if not is_on_floor():
		play_animation("jump")
	else:
		# 地面状态：根据是否有水平移动，切换run/idle
		if abs(direction) > 0:  # 有水平输入（在移动）
			$AnimatedSprite2D.flip_h = direction == -1
			play_animation("run")
		else:  # 无水平输入（闲置）
			play_animation("idle")


func _on_game_manager_health_changed(_new_health: int, change_amount: int, _max_health: int) -> void:
	if change_amount < 0:
		is_hurting = true
		hit_audio_player.play()
		print("hit!")
	 # Replace with function body.


func _on_invincibility_timer_timeout() -> void:
	is_hurting = false
