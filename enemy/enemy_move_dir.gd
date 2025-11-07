extends MovementDirection

@export var nav_agent: NavigationAgent3D
@export var current_position_node: Node3D;
@export var target: Node3D;
@export var distance_tolerance: float = 5;

@export var actionable_timer: Timer;
@export var attack_l: Attack;
@export var attack_r: Attack;

var direction_vec: Vector2 = Vector2.ZERO;

var safe_vec: Vector2 = Vector2.ZERO;

func _ready() -> void:
	self.nav_agent.velocity_computed.connect(self.on_velocity_computed);

func on_velocity_computed(safe_v: Vector3) -> void:
	#self.nav_agent.target_position = target.global_position;
	#var position: Vector3 = self.nav_agent.get_next_path_position();
	#if self.nav_agent.get_path_length() <= distance_tolerance:
		#self.direction_vec = Vector2.ZERO;
		#self._physics_process_in_range(delta);
		#return;
	print(safe_v);
	self.safe_vec = Vector2(safe_v.x,safe_v.z).normalized();

func _physics_process(delta: float) -> void:
	self.nav_agent.target_position = target.global_position;
	var position: Vector3 = self.nav_agent.get_next_path_position();
	if self.nav_agent.get_path_length() <= distance_tolerance:
		self.direction_vec = Vector2.ZERO;
		self._physics_process_in_range(delta);
		return;
	position -= self.current_position_node.global_position;
	self.direction_vec = (Vector2(position.x, position.z).normalized() + safe_vec * .75).normalized();
	self.safe_vec = Vector2.ZERO;

func _physics_process_in_range(_delta: float) -> void:
	if self.target.global_position.distance_to(self.current_position_node.global_position) > distance_tolerance:
		return;
	if !self.actionable_timer.is_stopped():
		return;
	
	(self.attack_l if randf()>.5 else self.attack_r).use(.5,.3);
	self.actionable_timer.start(.8);

func get_input_xz() -> Vector2:
	if !actionable_timer.is_stopped():
		return Vector2.ZERO;
	return self.direction_vec;
