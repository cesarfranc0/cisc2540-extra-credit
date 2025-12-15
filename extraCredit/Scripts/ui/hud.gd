extends CanvasLayer
class_name HUD

@onready var health_label: Label = $MarginContainer/VBoxContainer/HealthLabel
@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var damage_flash: ColorRect = $DamageFlash

func display_health(current: int, maxv: int) -> void:
	health_label.text = "HP: %d / %d" % [current, maxv]
	health_bar.max_value = maxv
	health_bar.value = current

func flash_red() -> void:
	# Stop any existing flash tween
	if damage_flash.get_child_count() > 0:
		for child in damage_flash.get_children():
			child.queue_free()

	damage_flash.color.a = 0.4

	var tween := get_tree().create_tween()
	tween.tween_property(damage_flash, "color:a", 0.0, 0.25)
