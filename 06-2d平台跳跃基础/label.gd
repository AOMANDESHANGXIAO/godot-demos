extends Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_player_player_die() -> void:
	self.visible = true # Replace with function body.
	animation_player.play("star")
