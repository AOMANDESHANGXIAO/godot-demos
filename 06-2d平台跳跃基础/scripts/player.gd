extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const MAX_HEALTH = 3
var health = MAX_HEALTH
var is_jumping = false
var is_hurting = false
var is_invince = false # 是否无敌
var safe_pos = Vector2.ZERO
signal health_changed(
	new_health: int,
	change_amount: int,
	max_health: int,
)
signal player_die

# 替换原有play_animation函数
@onready var animated_sprite = $AnimatedSprite2D  # 获取AnimatedSprite2D节点
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hit_audio_player: AudioStreamPlayer2D = $HitAudioPlayer
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var hit_timer: Timer = $HitTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if not health:
		return
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

func take_damage(val: int):
	if is_invince:
		# 无敌，不会受到伤害
		print("无敌！")
		return

	# 计算血量变化值（负数=掉血）
	var change_amount: int = -val  # 伤害值是扣除的血量，所以变化量为负
	# 更新血量（限制在0~MAX_HEALTH之间）
	var old_health: int = health
	health = max(health - val, 0)
	
	# 只有血量真的变化时才发射信号（避免重复触发）
	if health != old_health:
		print("受到伤害，当前血量: ", health)
		# 关键修复：发射信号时传递所有声明的参数
		emit_signal("health_changed", health, change_amount, MAX_HEALTH)
		if not health:
			emit_signal("player_die")
			visible = false
			return
		# 开启无敌状态
		is_invince = true
		is_hurting = true
		animation_player.play("invincity")
		invincibility_timer.start()
		hit_timer.start()
		
		
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
	is_invince = false
	animation_player.stop()

# 到达安全点，设置一下
func _on_check_point_player_arrived_safe_cell(pos: Vector2) -> void:
	safe_pos = pos # Replace with function body.

func _on_death_zoom_player_fall() -> void:
	position = safe_pos # Replace with function body.
	take_damage(1)

func _on_hit_timer_timeout() -> void:
	is_hurting = false # Replace with function body.
