extends Node

var coin = 0
signal coin_change

@onready var restart_game_timer: Timer = $RestartGameTimer

func _ready():
	print("game manager ready")

func collect_coin():
	coin += 1
	emit_signal("coin_change",coin)


func reload_game():
	get_tree().reload_current_scene()


func _on_player_player_die() -> void:
	restart_game_timer.connect("timeout",reload_game)
	restart_game_timer.start() # Replace with function body.
