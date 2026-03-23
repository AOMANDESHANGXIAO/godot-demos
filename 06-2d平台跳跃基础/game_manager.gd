extends Node

var coin = 0
var health = 3
var is_invince = false # 是否无敌

@onready var invincibility_timer: Timer = $InvincibilityTimer

signal coin_change
signal health_change

func collect_coin():
	coin += 1
	emit_signal("coin_change",coin)


func take_damage(val: int):
	if is_invince:
		# 无敌，不会受到伤害
		print("无敌！")
		return
	health = max(health-val,0)
	print("受到伤害")
	is_invince = true
	invincibility_timer.start()
	
	
