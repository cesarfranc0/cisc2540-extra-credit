extends Area2D
class_name DamageArea2D

@export var damage_amount: int = 1
@export var damage_type: String = "fire" # "poison" / "fire" / "spikes"
@export var tick_rate: float = 0.5       # seconds between ticks (DOT)
@export var one_shot: bool = false       # if true, damage only once on enter

var _inside: Dictionary = {} # body -> true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if one_shot:
		_apply_damage_to(body)
		return

	_inside[body] = true
	_dot_loop(body)

func _on_body_exited(body: Node) -> void:
	_inside.erase(body)

func _dot_loop(body: Node) -> void:
	while _inside.has(body) and is_instance_valid(body):
		_apply_damage_to(body)
		await get_tree().create_timer(tick_rate).timeout

func _apply_damage_to(body: Node) -> void:
	# Your player has a Hurtbox node; hazards talk to Hurtbox, not Health directly
	var hb := body.get_node_or_null("Hurtbox")
	if hb and hb.has_method("apply_damage"):
		hb.apply_damage(damage_amount, damage_type)
