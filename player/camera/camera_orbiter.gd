extends Node3D
class_name CameraOrbiter

@export var rotate_speed: float:
	get:
		return rotate_speed_src.value * .0002;

@export var rotate_speed_src: Range

@export_range(-180, 180, 0.001, "radians_as_degrees") var min_pitch: float = -PI/2;
@export_range(-180, 180, 0.001, "radians_as_degrees") var max_pitch: float = PI/2;

@export var pitch_speed_scale: float = -1;
@export var yaw_speed_scale: float = -1;

@export var interp_speed: float = 15;
@export var position_src: Node3D;

var pitch: float = 0;
var yaw: float = 0;

@export var target: Node3D;

var interp_angle_cd: float = 0;

func _process(delta: float) -> void:
	var interp_factor: float = 1. - exp(-delta * interp_speed);
	self.global_position = self.global_position.lerp(self.position_src.global_position, interp_factor);
	
	var speed_scale: float = self.rotate_speed * delta;
	pitch += Input.get_last_mouse_velocity().y * speed_scale * self.pitch_speed_scale;
	yaw += Input.get_last_mouse_velocity().x * speed_scale * self.yaw_speed_scale;
	
	pitch = clamp(pitch,self.min_pitch,self.max_pitch);
	
	if Input.get_last_mouse_velocity().x * speed_scale > .001:
		self.interp_angle_cd = 1;
	if self.interp_angle_cd > 0:
		self.interp_angle_cd -= delta;
	else:
		if self.target != null:
			var diff: Vector3 = (self.target.global_position - self.global_position);
			var y: float = fposmod(Vector2(-diff.z,-diff.x).angle(),PI * 2);
			var m: float = y;
			var min_val: float = abs(y - yaw);
			
			if abs(y - yaw + PI * 2) < min_val:
				min_val = abs(y - yaw + PI * 2);
				m = y + PI * 2;
			
			if abs(y - yaw - PI * 2) < min_val:
				m = y - PI * 2;
			yaw = lerp(yaw, m, (1 - interp_factor) * .025);
		
	yaw = fposmod(yaw, PI * 2);
	self.quaternion = Quaternion.from_euler(Vector3(pitch, yaw,0));
	
