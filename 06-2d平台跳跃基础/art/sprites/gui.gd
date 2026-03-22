extends Control

@onready var coin_label: Label = $CoinLabel


func _on_game_manager_coin_change(coin: int) -> void:
	coin_label.text = "Coin: " + str(coin)
