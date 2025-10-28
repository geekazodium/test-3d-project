@abstract
## universal movement character body
extends CharacterBody3D
class_name UMCharacterBody3D

@export var forced_friction: float = .1;

@export var movement_direction: MovementDirection;

func _physics_process(delta: float) -> void:
	var force: Vector3 = self.get_gravity();
	
	var input_direction: Vector2 = self.movement_direction.get_input_xz();
	
	var ideal_speed: float = self._get_ideal_speed();
	ideal_speed = max(ideal_speed, input_direction.dot(self._get_top_down_v()));
	var input_ideal_v: Vector2 = input_direction * ideal_speed;
	var input_force: Vector2 = input_ideal_v - self._get_top_down_v();
	input_force *= self._get_input_force_strength();
	force += -self.velocity * self.forced_friction;
	force.x += input_force.x;
	force.z += input_force.y;
	self.velocity += force * delta;
	self.move_and_slide();

func _get_top_down_v() -> Vector2:
	return Vector2(self.velocity.x,self.velocity.z);

@abstract
func _get_ideal_speed() -> float;

@abstract
func _get_input_force_strength() -> float;
