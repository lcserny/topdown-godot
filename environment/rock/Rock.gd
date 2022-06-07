extends Node2D

const RockDestroyedEffect = preload("res://environment/rock/DestroyedRockEffect.tscn")

func create_destroy_effect():
	var destroyEffect = RockDestroyedEffect.instance()
	get_parent().add_child(destroyEffect)
	destroyEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_destroy_effect()
	queue_free()
