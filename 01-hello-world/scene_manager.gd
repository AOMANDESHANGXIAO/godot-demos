extends Node

# 场景切换核心函数
func switch_to_scene(scene_path: String, trees: SceneTree) -> void:
	# 加载目标场景
	var next_scene = load(scene_path)
	if next_scene:
		# 切换场景（释放当前场景资源，避免内存泄漏）
		trees.change_scene_to_packed(next_scene)
	else:
		print("错误：场景路径不存在 → ", scene_path)
