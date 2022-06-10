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
export var PUSHBACK = 800
export var MIN_WANDER = 4

onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite = $AnimatedSprite
onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController= $WanderController
onready var animPlayer = $AnimationPlayer

func _ready():
	animatedSprite.playing = true

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			alter_wander_state()
		WANDER:
			seek_player()
			alter_wander_state()
			velocity = get_velocity_towards(delta, wanderController.target_position)
			if global_position.distance_to(wanderController.target_position) <= MIN_WANDER:
				update_wander_state()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				velocity = get_velocity_towards(delta, player.global_position)
			else:
				state = IDLE
	
	var push_vector = softCollision.get_push_vector()
	if softCollision.is_colliding(push_vector):
		velocity += push_vector * delta * PUSHBACK
	velocity = move_and_slide(velocity)

func get_velocity_towards(delta, position):
	var direction = global_position.direction_to(position)
	var new_velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	animatedSprite.flip_h = new_velocity.x < 0
	return new_velocity

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func alter_wander_state():
	if wanderController.get_time_left() == 0:
		update_wander_state()

func update_wander_state():
	state = choose_random_state([IDLE, WANDER])
	wanderController.set_wander_time(rand_range(1, 3))

func choose_random_state(states: Array):
	states.shuffle()
	return states.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK
	hurtbox.start_invincibility(0.3)
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	
	var slimeKilledEffect = SlimeKilledEffect.instance()
	slimeKilledEffect.global_position = global_position
	get_parent().add_child(slimeKilledEffect)

func _on_Hurtbox_invincibility_started():
	animPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animPlayer.play("Stop")
