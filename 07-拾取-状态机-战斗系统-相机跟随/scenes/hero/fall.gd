class_name Fall
extends State
@onready var walk: Walk = $"../Walk"

func enter()->void:
	anim_sprite.play("Fall")

func physics_update(_delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		actor.velocity.x = direction * walk.speed
		anim_sprite.flip_h = direction == -1
	if actor.is_on_floor():
		transitioned.emit("Fall","Idle")
	set_gravity_impact(_delta)
	actor.move_and_slide()
