extends MovementDirection

@export var input_yaw_src: Node3D;

@export var actionable_timer: Timer;

const FORWARD_INPUT: StringName = "move_forward";
const BACKWARD_INPUT: StringName = "move_backward";
const RIGHT_INPUT: StringName = "move_left";
const LEFT_INPUT: StringName = "move_right";

var user_input_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	self.update_user_input_dir();

func get_input_xz() -> Vector2:
	if !self.actionable_timer.is_stopped():
		return Vector2.ZERO;
	return self.user_input_direction;
	
func update_user_input_dir() -> void:
	var input_direction: Vector2 = Vector2(
		Input.get_axis("move_forward","move_backward"),
		Input.get_axis("move_right","move_left")
	);
	if input_direction.length_squared() > 1:
		input_direction = input_direction.normalized();
	self.user_input_direction = input_direction.rotated(-input_yaw_src.global_rotation.y + PI/2);
