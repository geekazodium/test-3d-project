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

var blocking_l: bool:
	get:
		return sign(block_direction) > 0;
var blocking_r: bool:
	get:
		return sign(block_direction) < 0;

var block_direction: float = 0;

const SPRINT_INPUT: StringName = "sprint";

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
			self.block_direction = Input.get_axis("move_right","move_left");

func attempt_hit(attack: Attack, knockback: Vector3, stun: float) -> void:
	if !self.block_active_timer.is_stopped():
		if (attack.l_blockable && self.blocking_l) ||\
		(attack.r_blockable && self.blocking_r):
			(attack.get_parent().get_parent() as UMCharacterBody3D).velocity = knockback * Vector3(-1,1,-1);
			self.block_cd_timer.stop();
			self.block_active_timer.stop();
			self.actionable_timer.stop();
			self.actionable_timer.start(.1);
			return;
	self.velocity += knockback;
	self.actionable_timer.start(stun);
