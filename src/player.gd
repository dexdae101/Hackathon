extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROT_SPEED = deg_to_rad(40)
const START_HP = 10
const DAMAGE = 10

var hp = START_HP

func _ready():
	Globals.player = self

func _physics_process(delta):
	if hp <= 0:
		position = Vector3.ZERO
		hp = START_HP
	if not is_on_floor():
		position.y = 0
	var direction = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction.z = -1 * SPEED
	if Input.is_action_pressed("backwards"):
		direction.z = 1 * SPEED
	if Input.is_action_pressed("left"):
		rotation.y += ROT_SPEED*delta
	if Input.is_action_pressed("right"):
		rotation.y -= ROT_SPEED*delta
	if Input.is_action_just_pressed("shoot"):
		if $RayCast3D.is_colliding():
			if $RayCast3D.get_collider().name == "Enemy":
				print("Hurting!")
				$RayCast3D.get_collider().hurt(DAMAGE)
	direction = direction.rotated(Vector3.UP, rotation.y)
	velocity = direction
	move_and_slide()

func round_excess(n: float):
	if n - int(n) > 0: return n+1
	else: return n
