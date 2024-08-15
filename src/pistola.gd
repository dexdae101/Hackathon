extends AnimatedSprite2D





func _on_player_shot():
	animation
	play("default")
	print("SHot!")
