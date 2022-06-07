extends KinematicBody2D

export var FRICTION = 1000
export var ACCELERATION = 1000
export var MAX_SPEED = 100

enum {
	MOVE,
	LAY,
	LAY_FINISHED,
	ATTACK
}

var state = MOVE

var velocity = Vector2.ZERO

onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hitboxCollision = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	hitboxCollision.disabled = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		LAY:
			lay_state(delta)
		ATTACK:
			attack_state(delta)
	
	if Input.is_action_just_pressed("lay") && state == LAY_FINISHED:
		getup_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
		
		if input_vector.x != 0: # fix for onlyleft-right animations
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/Attack/blend_position", input_vector)
			animationTree.set("parameters/Lay/blend_position", input_vector)
			animationTree.set("parameters/GetUp/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("lay"):
		state = LAY
	elif Input.is_action_just_pressed("attack"):
		state = ATTACK

func lay_state(delta):
	animationState.travel("Lay")

func lay_finished():
	state = LAY_FINISHED

func getup_state(delta):
	animationState.travel("GetUp")

func getup_finished():
	state = MOVE

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_finished():
	state = MOVE
