extends Node
# 1. 补充最大血量常量（信号需要传递max_health）
const MAX_HEALTH: int = 3  # 最大血量，和初始health保持一致
var coin = 0
var health = MAX_HEALTH
var is_invince = false # 是否无敌

@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var restart_game_timer: Timer = $RestartGameTimer

signal coin_change
signal health_changed(
	new_health: int,
	change_amount: int,
	max_health: int,
)
signal player_die

func collect_coin():
	coin += 1
	emit_signal("coin_change",coin)


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
			restart_game_timer.connect("timeout",reload_game)
			restart_game_timer.start()
			return
		# 开启无敌状态
		is_invince = true
		invincibility_timer.start()

func reload_game():
	get_tree().reload_current_scene()
