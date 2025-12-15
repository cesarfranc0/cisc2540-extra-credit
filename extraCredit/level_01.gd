extends Node2D

@onready var player: Node2D = $Player
@onready var health: Health = player.get_node("Health") as Health

func _ready() -> void:
	var hud := get_tree().get_first_node_in_group("hud")

	if hud == null:
		return

	if not hud.has_method("display_health"):
		return

	# Initial draw
	hud.display_health(health.current, health.max_health)

	# Live updates
	health.changed.connect(hud.display_health)
