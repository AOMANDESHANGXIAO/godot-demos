class_name State
extends Node

signal transitioned(state_name, new_state_name)

var actor: CharacterBody2D
var anim_sprite:AnimatedSprite2D

# Godot 4 默认重力加速度（方便计算）
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func set_gravity_impact(delta: float)->void:
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta
	
func enter()->void:
	pass

func exit()->void:
	pass

# _process 每一帧调用
func update(_delta: float) ->void:
	pass

# _physical_process 每一帧调用
func physics_update(_delta: float) -> void:
	pass
