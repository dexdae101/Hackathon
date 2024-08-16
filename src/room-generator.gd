#copyright RobelloStracciatello ltd, all right reserved
#sorry for the code not wall commented and documented, but I don't have enough time

class_name RoomGenerator

#declaration of numbers meaning
const Path=1
const Wall=2
const Door=3
const Root=4
const Files=5

static func InBorder(Matrix, x, y):                                   #checks if the given coordinates belongs to the border of the maze
	return x == 0 or x == len(Matrix) - 1 or y == 0 or y == len(Matrix[x]) - 1

static func IsNextToOnePath(Matrix, x, y):                            #checks if the given wall is next to only one path segment
	var count = 0
	if Matrix[x+1][y] == Path:
		count += 1
	if Matrix[x-1][y] == Path:
		count += 1
	if Matrix[x][y+1] == Path:
		count += 1
	if Matrix[x][y-1] == Path:
		count += 1
	return count == 1

static func AddSurroundingWalls(Matrix, x, y, Walls):							#add the surrounding walls of a path segment the the list of walls that could be replaced with a path segment
	if (Matrix[x+1][y] != Path):
		Matrix[x+1][y] = Wall
		if not InBorder(Matrix, x+1, y) and IsNextToOnePath(Matrix, x+1, y):			#only walls the are next to up to one path segment can be added to the list
			Walls.append([x+1, y])
	if (Matrix[x-1][y] != Path):
		Matrix[x-1][y] = Wall
		if not InBorder(Matrix, x-1, y) and IsNextToOnePath(Matrix, x-1, y):
			Walls.append([x-1, y])
	if (Matrix[x][y+1] != Path):
		Matrix[x][y+1] = Wall
		if not InBorder(Matrix, x, y+1) and IsNextToOnePath(Matrix, x, y+1):
			Walls.append([x, y+1])
	if (Matrix[x][y-1] != Path):
		Matrix[x][y-1] = Wall
		if not InBorder(Matrix, x, y-1) and IsNextToOnePath(Matrix, x, y-1):
			Walls.append([x, y-1])

static func DrawMatrix(Matrix):								#draws the maze
	for i in Matrix:
		for j in i:
			print(j)
		print()

static func CountPathNearEdge(Matrix, Edge, Paths):			#counts the path segments next to one of the edges of the maze, Edge is 0 or 1 or 2 and represent the left,up,right border
	var count = 0											#Paths is a list of path segments next to the edge selected, it should be an empty list, it will be populated during function excution
	if Edge == 0:
		for i in range(1, len(Matrix)-1):
			if Matrix[i][1] == Path:
				Paths.append([i, 0])
				count += 1
	elif Edge == 1:
		for i in range(1, len(Matrix[0])-1):
			if Matrix[1][i] == Path:
				Paths.append([0, i])
				count += 1
	else:
		for i in range(1, len(Matrix)-1):
			if Matrix[i][len(Matrix[i])-2] == Path:
				Paths.append([i, len(Matrix[i])-1])
				count += 1
	return count

static func GenerateMaze(Matrix, Walls, PathsList):									#it generates the maze, it takes the matrix where the maze is stored, and a list of walls that could be replaced with a path, only walls that are next to only one path could be replaced
	while Walls:															#PathsList is the list of the coordinates of all the path segments, it does not need to have datas in there and don't influece the function's steps
		var CurrentWall = Walls[randi_range(0, len(Walls)-1)]
		if IsNextToOnePath(Matrix, CurrentWall[0], CurrentWall[1]):
			Matrix[CurrentWall[0]][CurrentWall[1]] = Path
			PathsList.append([CurrentWall[0], CurrentWall[1]])
			AddSurroundingWalls(Matrix, CurrentWall[0], CurrentWall[1], Walls)
			Walls.erase(CurrentWall)
			
		else:
			Walls.erase(CurrentWall)

static func CountPaths(Matrix):								#only for debug purpose
	var count = 0
	for i in Matrix:
		for j in i:
			if j == Path:
				count += 1
	return count

static func GenerateMatrix(nCartels, nFiles):											#main function
	#seed()															#set the generation seed at the beginnig of execution (it should be alwas the same)
	var semiperimeter = int(log(nCartels+1)*log(nFiles+1) + nCartels/2 + 4*sqrt(nFiles))			#it calculates the semiperimeter of the maze based on the number of Cartels and Files. The moltiplicators are arbitrary so they can be tweaked as wanted. The function have to be concave
	var l1 = int(round(((3-sqrt(5))*semiperimeter)/2))                 #rounded golden ratio for the sides of the room
	var l2 = semiperimeter - l1
	#Matrix=[[Wall for i in range(l2) ] for _ in range(l1)]      #1 path segments, 2 walls, 3 doors, 4 root
	var Matrix = []
	for i in range(l1):
		Matrix.append([])
		for j in range(l2):
			Matrix[i].append(Wall)
	var Walls = []													#List of walls tha cuold become Path segments
	var WalkableArea = []												#List of path segments
	
	var DoorsOnL1 = round(l1*nCartels / (semiperimeter+l1))      #proportional distribution on the sides of the doors
	var DoorsOnL2 = nCartels-2*DoorsOnL1
	var DoorsConfig = [DoorsOnL1, DoorsOnL2]
	#print(DoorsOnL1,DoorsOnL2)

	var StartingPoint = randi_range(int(l2/5), l2-int(l2/5))		#random choose of the starting point of the maze in the lower side of the maze

	Matrix[len(Matrix)-2][StartingPoint] = Path
	#WalkableArea.append((len(Matrix)-2,StartingPoint))
	AddSurroundingWalls(Matrix, len(Matrix)-2, StartingPoint, Walls)		#initializing Walls list with the walls around the starting point

	GenerateMaze(Matrix, Walls, WalkableArea)

	for i in range(3):													#add doors in the sides of the maze, doors are placed in the three upper sides and are placed next to a path segment
		var Paths = []
		if DoorsConfig[i%2] <= CountPathNearEdge(Matrix, i, Paths):			#there are enough path segments next the the side
			for j in range(DoorsConfig[i%2]):
				var r = randi_range(0, len(Paths)-1)
				Matrix[Paths[r][0]][Paths[r][1]] = Door
				Paths.remove_at(r)
		else:															#the aren't enough path segments next to the side so I need to add more paths
			for j in Paths:
				Matrix[j[0]][j[1]] = Door
				#aggiungere qualcosa per estrarre casualmente le porte rimanenti, lo far� in un altro momento
			for j in range(DoorsConfig[i%2] - CountPathNearEdge(Matrix, i, Paths)):								#adding more paths
				var r = randi_range(1, ((i%2)*l2+(1-i%2)*l1)-2)
				#if i==0:
				#    while Matrix[r][0]==Door:
				#        r=randint(1,((i%2)*l2+(1-i%2)*l1)-2)
				#    Matrix[r][0]=Door
				#    Matrix[r][1]=Path
				#    Walls=[]
				#    AddSurroundingWalls(Matrix,(1-i%2)*(r-1)+1,(i-1)*(i-2)*(1/2)+i*(i-2)*(-r)+i*(i-1)*(len(Matrix[r])-2)/2,Walls)
				#    GenerateMaze(Matrix,Walls)
				#elif i==1:
				#    while Matrix[0][r]==Door:
				#        r=randint(1,((i%2)*l2+(1-i%2)*l1)-2)
				#    Matrix[0][r]=Door
				#    Matrix[1][r]=Path
				#    Walls=[]
				#    AddSurroundingWalls(Matrix,1,r,Walls)
				#    GenerateMaze(Matrix,Walls)
				#else:
				#    while Matrix[r][len(Matrix[r])-1]==Door:
				#        r=randint(1,((i%2)*l2+(1-i%2)*l1)-2)
				#    Matrix[r][len(Matrix[r])-1]=Door
				#    Matrix[r][len(Matrix[r])-2]=Path
				#    Walls=[]
				#    AddSurroundingWalls(Matrix,r,len(Matrix[r])-2,Walls)
				#    GenerateMaze(Matrix,Walls)
				while Matrix[(1-i%2)*r][int(-i*(i-2)*r+i*(i-1)*(len(Matrix[r])-1)/2)] == Door:                                         #Crazy indices to avoid ifs, I could replace with this metod other ifs. It works like the ifs above
					r = randi_range(1, ((i%2)*l2+(1-i%2)*l1)-2)
				Matrix[(1-i%2)*r][int(-i*(i-2)*r+i*(i-1)*(len(Matrix[r])-1)/2)] = Door
				Matrix[(1-i%2)*(r-1)+1][int((i-1)*(i-2)*(1/2)+i*(i-2)*(-r)+i*(i-1)*(len(Matrix[r])-2)/2)] = Path
				Walls = []
				AddSurroundingWalls(Matrix, (1-i%2)*(r-1)+1, int((i-1)*(i-2)*(1/2)+i*(i-2)*(-r)+i*(i-1)*(len(Matrix[r])-2)/2), Walls)
				GenerateMaze(Matrix, Walls, WalkableArea)

	Matrix[len(Matrix)-1][StartingPoint] = Root					#adding the start of the maze (parent folder)
	#print(CountPaths(Matrix))
	for i in range(nFiles):										#adding files random in the maze
		var r = randi_range(0, len(WalkableArea)-1)
		Matrix[WalkableArea[r][0]][WalkableArea[r][1]] = Files
		WalkableArea.remove_at(r)
	return Matrix