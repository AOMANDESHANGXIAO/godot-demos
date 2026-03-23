# 无敌时间计数器
extends Timer

@onready var game_manager: Node = %GameManager


func _on_timeout() -> void:
	game_manager.is_invince= false
