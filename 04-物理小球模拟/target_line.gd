extends Line2D

# 线条样式配置（可自定义）
@export var line_width: float = 3.0        # 线条宽度
@export var line_color: Color = Color(1, 0, 0)  # 红色线条
@export var line_z_index: int = 10         # 层级（确保在最上层）
@export var launch_force: float = 2000.0  
@export var ball_scene: PackedScene = load("res://ball.tscn")

var anchor_point: Vector2  # 屏幕下中点锚点
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 1. 初始化线条样式
	self.width = line_width
	self.default_color = line_color
	self.z_index = line_z_index
	# 2. 初始化锚点（屏幕下中点）
	update_anchor_point()
	# 3. 监听窗口大小变化（锚点需同步更新）
	get_viewport().size_changed.connect(update_anchor_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	 # 实时更新线条：连接锚点和鼠标位置
	update_line_to_mouse()
	
	# 鼠标左键按下时发射小球
	if Input.is_action_just_pressed("click"):  # 绑定鼠标左键为"click"（见下方说明）
		launch_ball_towards_mouse()


# 更新锚点坐标（屏幕下中点）
func update_anchor_point():
	# 获取视口（屏幕）大小
	var viewport_size = get_viewport_rect().size
	# 锚点 = (屏幕宽度/2, 屏幕高度)
	anchor_point = Vector2(viewport_size.x / 2, viewport_size.y)

# 更新线条顶点：锚点 → 鼠标位置
func update_line_to_mouse():
	if not is_instance_valid(self):
		return
	
	# 获取鼠标全局坐标
	var mouse_pos = get_global_mouse_position()
	
	# 设置线条顶点：第一个点=锚点，第二个点=鼠标位置
	self.clear_points()  # 清空旧顶点
	self.add_point(anchor_point)  # 锚点
	self.add_point(mouse_pos)     # 鼠标位置

# 核心：向鼠标方向发射小球
func launch_ball_towards_mouse():
	# 1. 校验Ball场景是否加载成功
	if not ball_scene:
		print("错误：未加载Ball场景！请检查路径")
		return
	
	# 2. 计算发射方向（鼠标位置 - 锚点）
	var mouse_pos = get_global_mouse_position()
	#var direction = (mouse_pos - anchor_point).normalized()  # 归一化（方向向量，长度=1）
	var direction = (mouse_pos - anchor_point).normalized()  # 归一化（方向向量，长度=1）
	# 3. 实例化小球，放在锚点位置
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = Vector2(anchor_point)
	add_child(ball_instance)
	ball_instance.global_position = anchor_point  # 小球初始位置=锚点
	
	# 4. 给小球设置发射速度（方向 × 力度）
	if ball_instance is RigidBody2D:
		# 关键：给刚体设置线速度（物理引擎驱动移动）
		ball_instance.linear_velocity = direction * launch_force
		# 可选：重置小球旋转（避免继承场景的旋转）
		ball_instance.rotation = 0.0
	else:
		print("错误：Ball场景根节点不是RigidBody2D！")
