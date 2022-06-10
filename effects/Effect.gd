extends AnimatedSprite

var with_sound = true

onready var soundPlayer = $AudioStreamPlayer

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")
	soundPlayer.playing = with_sound

func _on_animation_finished():
	queue_free()
