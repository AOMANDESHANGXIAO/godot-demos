extends HBoxContainer

@onready var player: CharacterBody2D = $"../../Player"

var heart_scene  = preload("res://scenes/heart.tscn")

func draw_health_heart(cnt: int):
		# 清空原有子节点（可选，避免重复创建）
	for child in get_children():
		child.queue_free()
	
	# 绘制2个爱心（你可以修改range(2)为任意数量，比如range(5)绘制5个）
	for i in range(cnt):
		# 1. 创建Control容器包裹Sprite2D
		var heart_container = Control.new()
		heart_container.custom_minimum_size = Vector2(64, 64)
		add_child(heart_container)
		
		# 2. 实例化爱心（Sprite2D）并添加到Control中
		var heart_instance = heart_scene.instantiate()
		heart_container.add_child(heart_instance)


func _ready()->void:
	draw_health_heart(player.health)


func _on_player_health_changed(new_health: int, _change_amount: int, _max_health: int) -> void:
	draw_health_heart(new_health) # Replace with function body.
