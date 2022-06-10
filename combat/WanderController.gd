extends Node2D

export(int) var wander_range = 16

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

func _ready():
	update_target_position()
	
func update_target_position():
	var wander_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + wander_vector

func get_time_left():
	return timer.time_left

func set_wander_time(time):
	timer.start(time)

func _on_Timer_timeout():
	update_target_position()