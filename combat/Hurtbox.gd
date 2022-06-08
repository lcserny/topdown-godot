extends Area2D

const HitEffect = preload("res://combat/HitEffect.tscn")

export(bool) var show_hit = true

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = HitEffect.instance()
		effect.global_position = global_position
		var main = get_tree().current_scene
		main.add_child(effect)
