extends MovementDirection

@export var nav_agent: NavigationAgent3D
@export var current_position_node: Node3D;
@export var target: Node3D;
@export var distance_tolerance: float = 5;


func get_input_xz() -> Vector2:
	self.nav_agent.target_position = target.global_position;
	var position: Vector3 = self.nav_agent.get_next_path_position();
	if self.nav_agent.get_path_length() <= distance_tolerance:
		return Vector2.ZERO;
	position -= self.current_position_node.global_position;
	return Vector2(position.x, position.z).normalized();
