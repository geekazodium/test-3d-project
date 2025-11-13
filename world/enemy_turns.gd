extends Node
class_name EnemyTurns

var next_turn_timestamp: int;

var enemies: Array[UMCharacterBody3D] = [];
var wait_turn_timers: Dictionary[UMCharacterBody3D, int] = {};
var current_enemy: UMCharacterBody3D;

func _ready() -> void:
	self.next_turn_timestamp = self._time();

func register(enemy: UMCharacterBody3D) -> void:
	self.enemies.append(enemy);
	self.wait_turn_timers.set(enemy, self._time());

func _time() -> int:
	return Time.get_ticks_msec();

func request_turn(enemy: UMCharacterBody3D) -> bool:
	if self.current_enemy != null:
		return false;
	if self.next_turn_timestamp - self._time() > 0:
		return false;
	if (self.wait_turn_timers[enemy] - self._time()) > 0:
		return false;
	self.current_enemy = enemy;
	return true;

func has_turn(enemy: UMCharacterBody3D) -> bool:
	return enemy == self.current_enemy;

func pass_turn(enemy: UMCharacterBody3D, cooldown_ms: int) -> bool:
	if self.current_enemy != enemy:
		return false;
	self.current_enemy = null;
	self.wait_turn_timers[enemy] = self._time() + cooldown_ms;
	return true;
