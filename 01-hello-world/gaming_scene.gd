extends Node2D

var scene_manager = preload("res://scene_manager.gd").new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_go_end_button_pressed() -> void:
	scene_manager.switch_to_scene("res://end_scene.tscn",get_tree()) # Replace with function body.
