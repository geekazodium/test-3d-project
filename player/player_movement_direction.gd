extends MovementDirection

@export var input_yaw_src: Node3D;

const FORWARD_INPUT: StringName = "move_forward";
const BACKWARD_INPUT: StringName = "move_backward";
const RIGHT_INPUT: StringName = "move_left";
const LEFT_INPUT: StringName = "move_right";

func get_input_xz() -> Vector2:
	var input_direction: Vector2 = Vector2(
		Input.get_axis("move_forward","move_backward"),
		Input.get_axis("move_right","move_left")
	);
	if input_direction.length_squared() > 1:
		input_direction = input_direction.normalized();
	return input_direction.rotated(-input_yaw_src.global_rotation.y + PI/2);
