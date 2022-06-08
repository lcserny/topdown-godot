extends Node2D

onready var player = $YSort/Player
onready var camera = $MainCamera

var stats = PlayerStats
var freezeCamera = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	stats.connect("no_health", self, "player_died")

func player_died():
	freezeCamera = true

func _process(delta):
	if !freezeCamera:
		camera.global_position = player.global_position
