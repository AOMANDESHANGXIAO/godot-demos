# StateMachine.gd
class_name StateMachine extends Node

# 导出变量：允许在编辑器中设置初始状态
@export var initial_state_name: State
var states: Dictionary = {}
@onready var current_state: State = null
@export var actor: CharacterBody2D # 引用拥有者
@export var anim_sprite: AnimatedSprite2D #引用动画

func _ready() -> void:
	# 收集所有子节点（即所有具体状态）
	for child in get_children():
		if child is State:
			var state = child as State
			child.anim_sprite = self.anim_sprite
			# 将状态添加到字典中，键为节点名
			states[state.name] = state
			state.actor = actor # 传递角色引用
			state.transitioned.connect(on_state_transition)

	# 检查并进入初始状态
	if initial_state_name:
		change_state(initial_state_name)
	else:
		printerr("Error: Initial state not set or not found.")

# 转换状态的核心函数
func change_state(new_state: State) -> void:
	# 1. 退出旧状态
	if current_state:
		current_state.exit()  
	# 2. 设置新状态
	current_state = new_state
	# 3. 进入新状态
	current_state.enter()

# 信号处理函数
func on_state_transition(state_name: String, new_state_name: String) -> void:
	# 确保是当前状态发出的转换请求
	if current_state and current_state.name == state_name:
		change_state(states[new_state_name])

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
