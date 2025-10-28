extends Camera3D

@export var shapecast: ShapeCast3D;

func _process(_delta: float) -> void:
	self.shapecast.force_shapecast_update();
	var safe_frac: float = self.shapecast.get_closest_collision_safe_fraction();
	self.position = shapecast.target_position * safe_frac;
