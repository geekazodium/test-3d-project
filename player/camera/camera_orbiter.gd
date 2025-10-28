extends Node3D
class_name CameraOrbiter

@export var rotate_speed: float = .01;

@export_range(-180, 180, 0.001, "radians_as_degrees") var min_pitch: float = -PI/2;
@export_range(-180, 180, 0.001, "radians_as_degrees") var max_pitch: float = PI/2;

@export var pitch_speed_scale: float = -1;
@export var yaw_speed_scale: float = -1;

var pitch: float = 0;
var yaw: float = 0;

func _process(delta: float) -> void:
	var speed_scale: float = self.rotate_speed * delta;
	pitch += Input.get_last_mouse_velocity().y * speed_scale * self.pitch_speed_scale;;
	yaw += Input.get_last_mouse_velocity().x * speed_scale * self.yaw_speed_scale;
	pitch = clamp(pitch,self.min_pitch,self.max_pitch);
	yaw = fposmod(yaw, PI * 2);
	self.quaternion = Quaternion.from_euler(Vector3(pitch, yaw,0));;
