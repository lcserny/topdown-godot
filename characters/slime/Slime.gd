extends KinematicBody2D

const SlimeKilledEffect = preload("res://characters/slime/SlimeKilledEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

export var FRICTION = 200
export var ACCELERATION = 500
export var MAX_SPEED = 50
export var KNOCKBACK = 150

onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite = $AnimatedSprite
onready var stats = $Stats
onready var hurtbox = $Hurtbox

func _ready():
	animatedSprite.playing = true

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			animatedSprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	
	var slimeKilledEffect = SlimeKilledEffect.instance()
	slimeKilledEffect.global_position = global_position
	get_parent().add_child(slimeKilledEffect)
