extends KinematicBody2D

const SlimeKilledEffect = preload("res://characters/slime/SlimeKilledEffect.tscn")

var knockback = Vector2.ZERO

const FRICTION = 600

onready var stats = $Stats

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150

func _on_Stats_no_health():
	queue_free()
	
	var slimeKilledEffect = SlimeKilledEffect.instance()
	get_parent().add_child(slimeKilledEffect)
	slimeKilledEffect.global_position = global_position
