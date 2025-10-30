extends Area3D

@export var l_blockable: bool;
@export var r_blockable: bool;

func _physics_process(delta: float) -> void:
	if self.get_overlapping_areas():
		pass
