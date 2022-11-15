extends KinematicBody2D

const ACCELERATION = 400	# velocity per sec
const MAX_SPEED = 100		# pixels per sec
const FRICTION = 400		# velocity per sec

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity) # velocity重新赋值可以让速度更新为碰撞后的新结果，以避免粘在碰撞边界的问题
	
	if velocity != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", velocity.normalized())
		animationTree.set("parameters/Run/blend_position", velocity.normalized())
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
