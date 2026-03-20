extends Node2D

@export var random_scene: PackedScene
var screen_size: Variant
var preset_colors = [
	Color(1, 0, 0),       # 纯红
	Color(0, 1, 0),       # 纯绿
	Color(0, 0, 1),       # 纯蓝
	Color(1, 1, 0),       # 黄色
	Color(1, 0, 1),       # 品红
	Color(0, 1, 1),       # 青色
	Color(0.5, 0.5, 0.5), # 灰色
	Color(1, 0.5, 0),     # 橙色
	Color(0.7, 0.2, 0.9), # 紫色
	Color(1, 1, 1)        # 白色
]
var score = 0

# 缩小+淡出动画
func play_shrink_and_fade_animation(target_node:Node):
	var tween = create_tween()
	var animation_duration = 0.8
	# 1. 缩放从（1，1）=> (0,0)
	tween.tween_property(target_node,"scale",Vector2(0,0),animation_duration)
	# 设置缓动曲线
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	# 2. 同时淡出透明度
	tween.parallel()
	tween.tween_property(target_node,"modulate:a",0.0,animation_duration)
	
	# 3. 动画结束销毁节点
	tween.finished.connect(func():
		target_node.queue_free()
	)

func on_instance_clicked(instance:Node, event:InputEvent):
	if instance.is_clicked:
		return
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				instance.is_clicked = true
				# 清除节点
				play_shrink_and_fade_animation(instance)
				score+=1
				$Label.text = "已点击"+str(score)+"次"
			MOUSE_BUTTON_RIGHT:
				print("右键按下")  # 右键
			MOUSE_BUTTON_MIDDLE:
				print("中键按下")  # 中键
	
func spawn_one_instance():
	var random_instance = random_scene.instantiate()
	random_instance.color = preset_colors.pick_random()
	random_instance.is_clicked = false
	var x = randi_range(0,screen_size.x)
	var y = randi_range(0,screen_size.y)
	var v = Vector2.ZERO
	v.x = x
	v.y = y
	random_instance.position = v
	add_child(random_instance)
	random_instance.gui_input.connect(func(event): on_instance_clicked(random_instance, event))

func spawn_instance_by_count(count: int):
	for i in range(count):
		spawn_one_instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	spawn_instance_by_count(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	spawn_one_instance() # Replace with function body.
