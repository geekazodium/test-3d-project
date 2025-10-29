extends UMCharacterBody3D

@export var move_speed: float = 5;
@export var sprint_speed: float = 8;
@export var input_force_strength: float = 10;
@export var air_input_force_strength: float = 1;

const SPRINT_INPUT: StringName = "sprint";

func _get_ideal_speed() -> float:
	return self.sprint_speed if Input.is_action_pressed(SPRINT_INPUT) else self.move_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength if self.is_on_floor() else self.air_input_force_strength;
