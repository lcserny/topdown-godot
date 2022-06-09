extends Node

export(int) var max_health = 1
var health = 1 setget set_health

signal no_health
signal health_changed(value)

func set_health(new_health):
	health = new_health
	emit_signal("health_changed", new_health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	health = max_health
