extends Area2D
class_name Hurtbox

signal took_damage(amount: int, damage_type: String)

@export var invuln_time: float = 0.25
var _invuln := false

func apply_damage(amount: int, damage_type: String) -> void:
	print("HURTBOX apply_damage called:", amount, damage_type, " invuln=", _invuln)
	if _invuln:
		return
	_invuln = true
	emit_signal("took_damage", amount, damage_type)
	await get_tree().create_timer(invuln_time).timeout
	_invuln = false
