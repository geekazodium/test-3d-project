extends CharacterBody3D

@export var move_speed: float = 100;
@export var sprint_speed: float = 150;
@export var forced_friction: float = .2;
@export var input_force_strength: float = 10;
@export var air_input_force_strength: float = 3;
@export var input_yaw_src: Node3D;

const FORWARD_INPUT: StringName = "move_forward";
const BACKWARD_INPUT: StringName = "move_backward";
const RIGHT_INPUT: StringName = "move_left";
const LEFT_INPUT: StringName = "move_right";

const SPRINT_INPUT: StringName = "sprint";

func _physics_process(delta: float) -> void:
	var force: Vector3 = self.get_gravity();
	
	var input_direction: Vector2 = self.get_input_vec_xz();
	
	var ideal_speed: float = self.sprint_speed if Input.is_action_pressed(SPRINT_INPUT) else self.move_speed;
	ideal_speed = max(ideal_speed, input_direction.dot(self._get_top_down_v()));
	var input_ideal_v: Vector2 = input_direction * ideal_speed;
	var input_force: Vector2 = input_ideal_v - self._get_top_down_v();
	input_force *= input_force_strength if self.is_on_floor() else air_input_force_strength;
	force += -self.velocity * self.forced_friction;
	force.x += input_force.x;
	force.z += input_force.y;
	self.velocity += force * delta;
	self.move_and_slide();

func get_input_vec_xz() -> Vector2:
	var input_direction: Vector2 = Vector2(
		Input.get_axis("move_forward","move_backward"),
		Input.get_axis("move_right","move_left")
	);
	if input_direction.length_squared() > 1:
		input_direction = input_direction.normalized();
	return input_direction.rotated(-input_yaw_src.global_rotation.y + PI/2);

func _get_top_down_v() -> Vector2:
	return Vector2(self.velocity.x,self.velocity.z);
