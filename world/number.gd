extends Label

func _process(delta: float) -> void:
	self.text = String.num_int64($"../CameraSpeed".value);
