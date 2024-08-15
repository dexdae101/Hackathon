extends CharacterBody3D

const SPEED: float = 2.0
const DAMAGE: float = 10
enum {
	ATTACK,
	IDLE,
	HIT
}

var state = IDLE
var attacco = false
var hp = 100
var target

func _physics_process(delta):
	choose_target()
	choose_enemy()
	update_state()
	$AnimatedSprite3D.rotation = Globals.player.rotation
	match state:
		IDLE:
			play_animation("Idle")
		ATTACK:
			play_animation("Walk")
			move(target.position, delta)
		HIT:
			play_animation("Attack")
			target.hp -= DAMAGE * delta
			attacco = false

func choose_target():
	var bodies = $Vision.get_overlapping_bodies()
	if bodies != []:
		for i in bodies:
			#prioritize players over evrey other object
			if i.name == "Player":
				target = i
				break
			#set nearest file as target
			elif i.is_in_group("file"):
				if target != null:
					if distance_to(i) < distance_to(target):
						target = i
				else:
					target = i
			#if no objects are detected set target to null
			else:
				target = null
func choose_enemy():
	#check if target is in the Attack zone
	var bodies = $Attack.get_overlapping_bodies()
	if bodies != [] and bodies.has(target): attacco = true
	else: attacco = false

func move(target, delta):
	var direction = (target - global_position).normalized()
	direction.y = 0
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
func update_state():
	if attacco:
		state = HIT
	elif target != null:
		state = ATTACK
	else:
		state = IDLE
func play_animation(animation: String):
	#wait for animations in wait_list to finish before playing the next animation
	const wait_list = ["Hurt", "Die"]
	if not $AnimatedSprite3D.animation in wait_list or not $AnimatedSprite3D.is_playing():
		$AnimatedSprite3D.play(animation)
func hurt(damage):
	hp -= damage
	if hp <= 0:
		$AnimatedSprite3D.play("Dead")
		queue_free()
	else:
		$AnimatedSprite3D.play("Hurt")
func distance_to(body):
	return (body.position - global_position).length()
