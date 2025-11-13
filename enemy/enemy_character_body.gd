extends UMCharacterBody3D
class_name Enemy

@export var ideal_speed: float = 5;
@export var input_force_strength: float = 10;
@export var _turn_handler: EnemyTurns;

var stop_input: bool = false;

func _get_ideal_speed() -> float:
	if stop_input:
		return 0;
	return self.ideal_speed;

func _get_input_force_strength() -> float:
	return self.input_force_strength;

func _ready() -> void:
	self._turn_handler.register(self);

func request_turn() -> bool:
	return self._turn_handler.request_turn(self);

func has_turn() -> bool:
	return self._turn_handler.has_turn(self);

func pass_turn() -> bool:
	return self._turn_handler.pass_turn(self,2000);
