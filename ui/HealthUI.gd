extends Control

var stats = PlayerStats
var hearts = 1 setget set_hearts
var max_hearts = 1

var heartSize = 16

onready var filledHearts = $FilledHearts
onready var emptyHearts = $EmptyHearts

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	adjust_filled_hearts_ui()

func adjust_empty_hearts_ui():
	if emptyHearts != null:
		emptyHearts.rect_size.x = max_hearts * heartSize
	
func adjust_filled_hearts_ui():
	if filledHearts != null:
		filledHearts.rect_size.x = hearts * heartSize

func _ready():
	stats.connect("health_changed", self, "set_hearts")
	hearts = stats.health
	max_hearts = stats.max_health
	
	adjust_empty_hearts_ui()
	adjust_filled_hearts_ui()
