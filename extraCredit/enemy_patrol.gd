extends CharacterBody2D

@export var speed: float = 80.0
@export var patrol_distance: float = 160.0
@export var start_direction: int = 1 # 1 = right, -1 = left

@export var damage_amount: int = 1
@export var damage_type: String = "enemy"
@export var contact_cooldown: float = 0.5

@onready var hitbox: Area2D = $Hitbox
@onready var visual: Node = $Visual

var _origin_x: float
var _dir: int
var _can_damage: bool = true
var _attacking: bool = false


func _ready() -> void:
	_origin_x = global_position.x
	_dir = 1 if start_direction >= 0 else -1

	# Use area_entered so we can detect the player's Hurtbox (Area2D)
	hitbox.area_entered.connect(_on_hitbox_area_entered)

	_update_visual_flip()
	_update_anim()


func _physics_process(_delta: float) -> void:
	# Optional: stop moving during attack so it's readable/fair
	if _attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Patrol
	velocity = Vector2(_dir * speed, 0.0)
	move_and_slide()

	# Bounds
	var left_bound := _origin_x - patrol_distance * 0.5
	var right_bound := _origin_x + patrol_distance * 0.5

	if global_position.x <= left_bound:
		global_position.x = left_bound
		_dir = 1
	elif global_position.x >= right_bound:
		global_position.x = right_bound
		_dir = -1

	_update_visual_flip()
	_update_anim()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not _can_damage or _attacking:
		return

	# Best case: we directly touched the player's Hurtbox
	if area is Hurtbox:
		(area as Hurtbox).apply_damage(damage_amount, damage_type)
		_start_contact_cooldown()
		_play_attack()
		return

	# Fallback: if the entered area belongs to a Player, try to find Hurtbox on the owner
	var owner := area.owner
	if owner:
		var hb := owner.get_node_or_null("Hurtbox")
		if hb and hb.has_method("apply_damage"):
			hb.apply_damage(damage_amount, damage_type)
			_start_contact_cooldown()
			_play_attack()


func _play_attack() -> void:
	var a := visual as AnimatedSprite2D
	if a == null or a.sprite_frames == null:
		return
	if not a.sprite_frames.has_animation("attack"):
		return

	_attacking = true

	a.stop()
	a.frame = 0
	a.play("attack")

	# attack animation should NOT loop
	await a.animation_finished

	_attacking = false
	_update_anim()


func _start_contact_cooldown() -> void:
	_can_damage = false
	await get_tree().create_timer(contact_cooldown).timeout
	_can_damage = true


func _update_anim() -> void:
	var a := visual as AnimatedSprite2D
	if a == null or a.sprite_frames == null:
		return

	# Don't override attack mid-play
	if _attacking:
		return

	if abs(velocity.x) > 0.1 and a.sprite_frames.has_animation("run"):
		if a.animation != "run":
			a.play("run")
	elif a.sprite_frames.has_animation("idle"):
		if a.animation != "idle":
			a.play("idle")


func _update_visual_flip() -> void:
	if visual is AnimatedSprite2D:
		(visual as AnimatedSprite2D).flip_h = _dir < 0
	elif visual is Sprite2D:
		(visual as Sprite2D).flip_h = _dir < 0
