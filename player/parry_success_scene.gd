extends MeshInstance3D

var defualt_albedo: Color:
	get: 
		return default_albedo_base * 3;

@export var color_lerp_rate: float = 10;

@export var scale_increase_rate: float = 8;

@export var default_albedo_base: Color = Color.REBECCA_PURPLE;
@export var max_scale: float = 0;

func _ready() -> void:
	(self.get_surface_override_material(0) as StandardMaterial3D).albedo_color = defualt_albedo;

func _process(delta: float) -> void:
	self.scale += delta * (Vector3.ONE * scale_increase_rate - self.scale * 2);
	if self.scale.x > max_scale:
		self.queue_free();
	#print((self.get_surface_override_material(0) as StandardMaterial3D).albedo_color);
	(self.get_surface_override_material(0) as StandardMaterial3D).albedo_color -= self.defualt_albedo * delta * color_lerp_rate;
	self.set_surface_override_material(0,self.get_surface_override_material(0));
