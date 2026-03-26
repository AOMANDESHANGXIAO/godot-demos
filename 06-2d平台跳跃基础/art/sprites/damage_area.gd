extends Area2D

@export var damage = 1

@onready var player: CharacterBody2D = $"../../../Player"

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player.take_damage(damage)
