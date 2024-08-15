extends CharacterBody3D

@export var SPEED: float = 2.0
@export var DAMAGE: float = 10
var hp = 100
enum {
	ATTACK,
	IDLE,
	HIT
}

var state = IDLE
var visto = false
var attacco = false

func move(target, delta):
	var direction = (target - global_position).normalized()
	direction.y = 0
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func _physics_process(delta):
	$AnimatedSprite3D.rotation = Globals.player.rotation
	update_state()
	if not is_on_floor():
		velocity.y = 0
	match state:
		IDLE:
			if check_animation():
				$AnimatedSprite3D.play("Idle")
		ATTACK:
			if check_animation():
				$AnimatedSprite3D.play("Walk")
			move(Globals.player.position, delta)
		HIT:
			if check_animation():
				$AnimatedSprite3D.play("Attack")
			Globals.player.hp -= DAMAGE * delta
			state = ATTACK

func update_state():
	if attacco:
		state = HIT
	elif visto:
		state = ATTACK
	elif not visto:
		state = IDLE

func check_animation():
	if not $AnimatedSprite3D.animation in ["Hurt", "Die"] : return true
	else: 
		return not $AnimatedSprite3D.is_playing()
		
func hurt(damage):
	hp -= damage
	if hp <= 0:
		$AnimatedSprite3D.play("Dead")
		queue_free()
	else:
		$AnimatedSprite3D.play("Hurt")
#collision checks
func _on_vision_body_entered(body):
	if body.name == "Player":
		visto = true

func _on_vision_body_exited(body):
	if body.name == "Player":
		visto = false

func _on_attack_body_entered(body):
	if body.name == "Player":
		attacco = true

func _on_attack_body_exited(body):
	if body.name == "Player":
		attacco = false
