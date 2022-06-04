extends Node2D

onready var RockDestroyedEffect = load("res://environment/rock/RockDestroyedEffect.tscn")

func create_destroy_effect():
	var effect = RockDestroyedEffect.instance()
	var world = get_tree().current_scene
	world.add_child(effect)
	effect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_destroy_effect()
	queue_free()
