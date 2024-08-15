extends CharacterBody3D

@export var SPEED: float = 2.0
@export var DAMAGE: float = 10
var hp = 100
enum {
	ATTACK,
	IDLE,
	HIT,
}

var state = IDLE
var attacco = false
var target

func move(target, delta):
	var direction = (target - global_position).normalized()
	direction.y = 0
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func choose_target():
	if $Vision.get_overlapping_bodies() != []:
		for i in $Vision.get_overlapping_bodies():
			if i.name == "Player":
				target = i
				break
			elif i.is_in_group("file"):
				if target != null:
					if distance_to(i) < distance_to(target):
						target = i
				else:
					target = i
			else:
				target = null
func choose_enemy():
	if $Attack.get_overlapping_bodies() != [] and $Attack.get_overlapping_bodies().has(target):
		attacco = true
	else: attacco = false
func _physics_process(delta):
	choose_target()
	choose_enemy()
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
			move(target.position, delta)
		HIT:
			if check_animation():
				$AnimatedSprite3D.play("Attack")
			target.hp -= DAMAGE * delta
			attacco = false
			
func update_state():
	if attacco:
		state = HIT
	elif target != null:
		state = ATTACK
	else:
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
		
func distance_to(body):
	return (body.position - global_position).length()
