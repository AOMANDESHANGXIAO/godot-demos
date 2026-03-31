class_name Player 
extends CharacterBody2D

# 引用状态机节点
@onready var state_machine: StateMachine = $StateMachine
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# 角色的属性变量
@export var speed = 400
@export var jump_velocity = -550
var is_attacking = false
@export var attack_speed = 0.4


func _ready() -> void:
	# 将自身的引用传递给状态机，以便状态可以控制角色
	state_machine.actor = self
	#state_machine._ready() # 确保状态机初始化 似乎多余了，因为会自己调用
	
# 注意：现在 _physics_process 由状态机和当前状态来管理，
# Player 脚本本身不再直接处理复杂的运动逻辑。
func _physics_process(delta: float) -> void:
	state_machine._physics_process(delta)

func _process(delta: float) -> void:
	state_machine._process(delta)
