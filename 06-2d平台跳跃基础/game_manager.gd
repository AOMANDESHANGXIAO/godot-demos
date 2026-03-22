extends Node

var coin = 0
var health = 3

signal coin_change
signal health_change

func collect_coin():
	coin += 1
	emit_signal("coin_change",coin)

func get_damage(damage: int):
	health -= damage
	emit_signal("coin_change",coin)
