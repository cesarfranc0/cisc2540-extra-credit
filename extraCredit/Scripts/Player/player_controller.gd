extends CharacterBody2D

@export var speed: float = 220.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: Health = $Health
@onready var hurtbox: Hurtbox = $Hurtbox

var _dead := false
var _playing_hurt := false


func _ready() -> void:
	hurtbox.took_damage.connect(_on_took_damage)
	health.died.connect(_on_died)

	_play_anim("idle", true)


func _physics_process(_delta: float) -> void:
	if _dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input * speed
	move_and_slide()

	if not _playing_hurt:
		_update_move_anim(input)


func _input(event: InputEvent) -> void:
	# TEMP test damage (remove later if desired)
	if event.is_action_pressed("ui_accept"):
		hurtbox.apply_damage(1, "test")


func _update_move_anim(input: Vector2) -> void:
	if input.length() > 0.0:
		_play_anim("run")
		if input.x != 0.0:
			anim.flip_h = input.x < 0.0
	else:
		_play_anim("idle")


func _on_took_damage(amount: int, _damage_type: String) -> void:
	if _dead:
		return

	health.damage(amount)

	# Screen flash on any damage
	var hud := get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("flash_red"):
		hud.flash_red()

	if health.current <= 0:
		return

	_play_hurt()


func _play_hurt() -> void:
	if _playing_hurt or _dead:
		return

	_playing_hurt = true

	anim.stop()
	anim.frame = 0
	anim.play("hurt")

	await anim.animation_finished

	_playing_hurt = false

	var input := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	_update_move_anim(input)


func _on_died() -> void:
	_dead = true
	_playing_hurt = false

	anim.stop()
	anim.frame = 0
	anim.play("death")

	velocity = Vector2.ZERO


func _play_anim(name: String, force_restart := false) -> void:
	if anim.sprite_frames == null:
		return
	if not anim.sprite_frames.has_animation(name):
		return

	if force_restart:
		anim.stop()
		anim.frame = 0
		anim.play(name)
		return

	if anim.animation != name:
		anim.play(name)
