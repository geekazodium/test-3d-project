extends Area3D

func _ready() -> void:
	self.body_entered.connect(self._on_body_enter);
	
func _on_body_enter(body: PhysicsBody3D) -> void:
	body.position = Vector3.ZERO;
