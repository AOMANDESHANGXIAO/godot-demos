extends Area2D

@onready var timer: Timer = $Timer
signal player_fall
func _on_body_entered(_body: Node2D) -> void:
	#Engine.time_scale = 0.5
	#body.get_node("CollisionShape2D").queue_free()
	#timer.start()
	timer.start()

func _on_timer_timeout() -> void:
	#Engine.time_scale = 1.0
	#get_tree().reload_current_scene()
	emit_signal("player_fall")
