extends RigidBody2D

# 可选：边界检测的缓冲值（避免小球边缘刚出界就销毁，可自定义）
@export var boundary_buffer: float = 50.0

func _process(_delta):
	# 实时检测是否超出窗口范围
	if is_outside_viewport():
		print("销毁小球")
		queue_free()  # 安全销毁节点（等待当前帧结束后删除）

# 核心：判断小球是否超出视口（窗口）范围
func is_outside_viewport() -> bool:
	# 获取视口（窗口）的矩形范围（带缓冲值）
	var viewport_rect = get_viewport_rect()
	var expanded_rect = Rect2(
		viewport_rect.position - Vector2(boundary_buffer, boundary_buffer),
		viewport_rect.size + Vector2(boundary_buffer * 2, boundary_buffer * 2)
	)
	
	# 检测小球的全局坐标是否在视口范围外
	return not expanded_rect.has_point(global_position)
