extends Node
class_name Health

signal changed(current: int, max: int)
signal died

@export var max_health: int = 5
var current: int

func _ready() -> void:
	current = max_health
	emit_signal("changed", current, max_health)

func damage(amount: int) -> void:
	if amount <= 0 or current <= 0:
		return
	current = max(current - amount, 0)
	emit_signal("changed", current, max_health)
	if current == 0:
		emit_signal("died")

func heal(amount: int) -> void:
	if amount <= 0 or current <= 0:
		return
	current = min(current + amount, max_health)
	emit_signal("changed", current, max_health)

func reset_full() -> void:
	current = max_health
	emit_signal("changed", current, max_health)
