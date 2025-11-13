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
	self.safe_vec = Vector2(safe_v.x,safe_v.z).normalized();

func _physics_process(delta: float) -> void:
	self.nav_agent.target_position = target.global_position;
	var position: Vector3 = self.nav_agent.get_next_path_position();
	position -= self.current_position_node.global_position;
	if !self.actionable_timer.is_stopped():
		(self.get_parent() as Enemy).stop_input = true;
	if self.nav_agent.get_path_length() <= distance_tolerance:
		self.direction_vec = Vector2.ZERO;
		var exit: bool = self._physics_process_in_range(delta);
		if !exit:
			self.direction_vec = safe_vec.normalized();
			self.safe_vec = Vector2.ZERO;
		else:
			(self.get_parent() as Enemy).stop_input = true;
		return;
	self.direction_vec = (Vector2(position.x, position.z).normalized() + safe_vec * .75).normalized();
	self.safe_vec = Vector2.ZERO;
	(self.get_parent() as Enemy).stop_input = false;

var combo_count: float = 0;

func _physics_process_in_range(_delta: float) -> bool:
	var position: Vector3 = self.target.global_position - self.get_parent().global_position;
	self.direction_vec = Vector2(position.x, position.z).normalized();
	if !self.actionable_timer.is_stopped():
		return true;
	if self.target.global_position.distance_to(self.current_position_node.global_position) > distance_tolerance:
		return false;
	var _parent: Enemy = self.get_parent();
	if !_parent.has_turn():
		var success: bool = _parent.request_turn();
		if success:
			self.combo_count = 0;
		else:
			return false;
	
	if randf() < 1-exp(-combo_count):
		_parent.pass_turn();
		return false;
	combo_count += 1;
	
	(self.attack_l if randf()>.5 else self.attack_r).use(.5,.3);
	self.actionable_timer.start(.8);
	return true;

func get_input_xz() -> Vector2:
	#if !actionable_timer.is_stopped():
		#return Vector2.ZERO;
	return self.direction_vec;
