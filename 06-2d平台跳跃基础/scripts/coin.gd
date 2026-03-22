extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

 
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_manager.collect_coin()
		animation_player.play("pickup")
	 # Replace with function body.
