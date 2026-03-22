extends Label


func _on_game_manager_coin_change(cnt: int) -> void:
	self.text = "Coin: " +  str(cnt)# Replace with function body.
