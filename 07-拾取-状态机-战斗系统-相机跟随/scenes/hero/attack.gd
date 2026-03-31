class_name Attck
extends State


func enter()->void:
	actor.velocity.x = 0 # 攻击时站立不动
	actor.is_attacking = true
	anim_sprite.speed_scale = (1+actor.attack_speed)
	anim_sprite.play("Attack")


func physics_update(_delta: float) -> void:
	set_gravity_impact(_delta)
	if not actor.is_attacking:
		transitioned.emit("Attack","Idle")

func _on_animated_sprite_2d_animation_finished() -> void:
	print("攻击停止")
	actor.is_attacking = false # Replace with function body.
	anim_sprite.speed_scale = 1
