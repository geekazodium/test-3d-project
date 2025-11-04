extends MeshInstance3D

@export var parry_active: Timer;

func _process(delta: float) -> void:
	self.visible = !self.parry_active.is_stopped();
