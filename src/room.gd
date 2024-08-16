extends Node3D

const tile_center = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var doors = []
	var floors = []
	var roofs = []
	var walls = []
	var files = []
	var room_matrix = RoomGenerator.GenerateMatrix(5, 5)
	RoomGenerator.DrawMatrix(room_matrix)
	const door = preload("res://scenes/tiles/door.tscn")
	const floor = preload("res://scenes/tiles/floor.tscn")
	const roof = preload("res://scenes/tiles/roof.tscn")
	const wall = preload("res://scenes/tiles/wall.tscn")
	const file = preload("res://scenes/file.tscn")

	for i in range(len(room_matrix)):
		for j in range(len(room_matrix[i])):
			match room_matrix[i][j]:
				1:
					floors.append(floor.instantiate())
					add_child(floors[-1])
					floors[-1].position = Vector3i(j * tile_center, 0, i * tile_center)
				2:
					walls.append(wall.instantiate())
					add_child(walls[-1])
					walls[-1].position = Vector3i(j * tile_center, 0, i * tile_center)
				3:
					doors.append(door.instantiate())
					add_child(doors[-1])
					if i == 0:
						doors[-1].rotate_y(0)
					elif j == 0:
						doors[-1].rotate_y(PI/2)
					elif i == len(room_matrix)-1:
						doors[-1].rotate_y(PI)
					elif j == len(room_matrix[i])-1:
						doors[-1].rotate_y(-PI/2)
					doors[-1].position = Vector3i(j * tile_center, 0, i * tile_center)
				4:
					doors.append(door.instantiate())
					add_child(doors[-1])
					doors[-1].position = Vector3i(j * tile_center, 0, i * tile_center)
					doors[-1].rotate_y(PI)
				5:
					floors.append(floor.instantiate())
					add_child(floors[-1])
					floors[-1].position = Vector3i(j * tile_center, 0, i * tile_center)

					files.append(file.instantiate())
					add_child(files[-1])
					files[-1].position.x = j * tile_center
					files[-1].position.z = i * tile_center



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
