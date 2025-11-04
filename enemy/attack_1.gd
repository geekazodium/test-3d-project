extends Area3D
class_name Attack

@export var l_blockable: bool;
@export var r_blockable: bool;
@export var knockback: Vector3;
@export var stun_seconds: float;

@export var windup_indicator: MeshInstance3D;

func _ready() -> void:
	self.visible = false;
	self.monitoring = false;

func _physics_process(_delta: float) -> void:
	if !self.monitoring:
		return;
	if self.get_overlapping_bodies().size() > 0:
		for b in self.get_overlapping_bodies():
			if b is PlayerCharacter:
				b.attempt_hit(
					self,
					self.knockback * Quaternion.from_euler(-self.global_rotation) - b.velocity,
					self.stun_seconds
				);
				self.monitoring = false;

func use(windup: float,active_seconds: float) -> void:
	self.windup_indicator.visible = true;
	await self.get_tree().create_timer(windup).timeout;
	self.windup_indicator.visible = false;
	self.visible = true;
	self.monitoring = true;
	await self.get_tree().create_timer(active_seconds).timeout;
	self.visible = false;
	self.monitoring = false;
