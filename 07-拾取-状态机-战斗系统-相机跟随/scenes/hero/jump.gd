class_name Jump
extends State


func enter()->void:
	actor.velocity.y = actor.jump_velocity
	anim_sprite.play("Jump")

func physics_update(_delta: float) -> void:
	set_gravity_impact(_delta)
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		actor.velocity.x = direction * actor.speed
		anim_sprite.flip_h = direction == -1
	if actor.velocity.y >= 0:
		# 切换为Fall状态
		transitioned.emit("Jump","Fall")
	actor.move_and_slide()

	
