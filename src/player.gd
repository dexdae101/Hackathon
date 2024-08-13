extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROT_SPEED = deg_to_rad(40)

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction.z = -1 * SPEED
	if Input.is_action_pressed("backwards"):
		direction.z = 1 * SPEED
	if Input.is_action_pressed("left"):
		rotation.y += ROT_SPEED*delta
	if Input.is_action_pressed("right"):
		rotation.y -= ROT_SPEED*delta
	direction = direction.rotated(Vector3.UP, rotation.y)
	velocity = direction
	move_and_slide()

func round_excess(n: float):
	if n - int(n) >0: return n+1
	else: return n
