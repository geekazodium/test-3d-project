extends UMCharacterBody3D
class_name PlayerCharacter

@export var move_speed: float = 5;
@export var sprint_speed: float = 8;
@export var input_force_strength: float = 10;
@export var air_input_force_strength: float = 1;

var block_cd_timer: Timer:
	get:
		return $BlockCdTimer;
var block_active_timer: Timer:
	get:
		return $BlockActiveTimer;

var actionable_timer: Timer:
	get:
		return $ActionableTimer;

var block_direction: Vector2 = Vector2.ZERO;

const SPRINT_INPUT: StringName = "sprint";

@export var camera_dir: CameraOrbiter;

@export var parry_success_scene: PackedScene;

func _ready() -> void:
	self.block_active_timer.stop();
	self.block_cd_timer.stop();

func _get_ideal_speed() -> float:
	if !self.block_cd_timer.is_stopped():
		return 0;
	return self.sprint_speed if Input.is_action_pressed(SPRINT_INPUT) else self.move_speed;

func _get_input_force_strength() -> float:
	#if !self.block_cd_timer.is_stopped():
		#return 0;
	return self.input_force_strength if self.is_on_floor() else self.air_input_force_strength;

func _physics_process(delta: float) -> void:
	super._physics_process(delta);
	if self.block_cd_timer.is_stopped():
		if Input.is_action_just_pressed("block"):
			self.actionable_timer.start(self.block_cd_timer.wait_time);
			self.block_cd_timer.start();
			self.block_active_timer.start();
			self.block_direction = self.camera_dir.direction;
			if sign(Input.get_axis("move_right","move_left")) < 0:
				self.parry_r = true;
				self.parry_l = false;
			elif sign(Input.get_axis("move_right","move_left")) > 0:
				self.parry_r = false;
				self.parry_l = true;
			else: 
				self.parry_l = false;
				self.parry_r = false;

var parry_l: bool;
var parry_r: bool;

func attempt_hit(attack: Attack, knockback: Vector3, stun: float) -> void:
	var pos_diff = (attack.global_position - self.global_position) * Vector3(1,0,1);
	pos_diff = pos_diff.normalized();
	
	var d: Vector3 = Vector3(block_direction.x,0,block_direction.y).normalized();
	
	var max_angle: float = PI * 4/5;
	if d.dot(pos_diff) < cos(max_angle):
		return;
	
	if !self.block_active_timer.is_stopped():
		if (attack.l_blockable && self.parry_l) ||\
		(attack.r_blockable && self.parry_r):
			(attack.get_parent().get_parent() as UMCharacterBody3D).velocity = knockback * Vector3(-1,1,-1);
			self.block_cd_timer.stop();
			self.block_active_timer.stop();
			self.actionable_timer.stop();
			self.actionable_timer.start(.1);
			self.add_child(self.parry_success_scene.instantiate());
			return;
	self.velocity += knockback;
	self.actionable_timer.start(stun);
