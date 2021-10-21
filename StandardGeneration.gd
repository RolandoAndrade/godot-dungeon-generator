extends DungeonStrategy

class_name StandardDungeonGenerator

## _M/_N should be equals 2/3
var _M: int
var _N: int

const MINIMUM_ROOM_WIDTH = 5
const MINIMUM_ROOM_HEIGHT = 4

enum TypeOfRoom {
	ROOM,
	DUMMY_ROOM,
}

var rooms: Array = []


func _init(grid: Vector2):
	_M = grid.x
	_N = grid.y

func _get_number_of_rooms(density: int) -> int:
	var number_of_rooms = 0
	if density < 0:
		number_of_rooms = abs(density)
	else:
		number_of_rooms = randi() % 2 + density
	return number_of_rooms

func _get_rooms_order(
	number_of_rooms: int, 
	number_of_dummy_rooms: int) -> Array:
	var to_create = []
	for i in number_of_rooms:
		to_create.append(TypeOfRoom.ROOM)
	for j in number_of_dummy_rooms:
		to_create.append(TypeOfRoom.DUMMY_ROOM)
	to_create.shuffle()
	return to_create

func _create_room(
	n: int, 
	m: int, 
	max_width: int, 
	max_height: int) -> Room:
		
	var top = n * max_height
	var left = m * max_width
	var width = max_width
	var height = max_height
	
	if MINIMUM_ROOM_WIDTH < max_width:
		width = randi() % (max_width - MINIMUM_ROOM_WIDTH) + MINIMUM_ROOM_WIDTH
	if MINIMUM_ROOM_HEIGHT < max_height:
		height = randi() % (max_height - MINIMUM_ROOM_HEIGHT) + MINIMUM_ROOM_HEIGHT
	
	var padding_left = (max_width - width) / 2
	var padding_top = (max_height - height) / 2
	for i in height:
		for j in width:
			dungeon[top + padding_top + i][left + padding_left + j] = 1
	
	return Room.new(Rect2(left + padding_left, top + padding_top, width, height))
	
func _create_dummy_room(
	n: int, 
	m: int, 
	max_width: int,
	 max_height: int):
		
	var top = n * max_height
	var left = m * max_width
	var x = max_width / 2 + left
	var y = max_height / 2 + top
	
	dungeon[y][x] = 1
	return Room.new(Rect2(x, y, 1, 1))
	
func _place_rooms(width: int, height: int, density: int):
	var room_max_width = int(width / _M)
	var room_max_height = int(height / _N)
	var number_of_rooms = _get_number_of_rooms(density)
	var number_of_dummy_rooms = _M * _N - number_of_rooms 
	var rooms_order = _get_rooms_order(number_of_rooms, number_of_dummy_rooms)
	rooms = []
	for i in _N:
		var row_rooms = []
		for j in _M:
			var room_type = rooms_order[i * _M + j]
			match room_type:
				TypeOfRoom.ROOM:
					row_rooms.append(
						_create_room(i, j, room_max_width, room_max_height))
				TypeOfRoom.DUMMY_ROOM:
					row_rooms.append(
						_create_dummy_room(i, j, room_max_width, room_max_height))
		rooms.append(row_rooms)

func _select_collinear_points_parallel_to(a: Room, b: Room, direction: String):
	var x1
	var x2
	var y1
	var y2
	if direction == "vertical":
		x1 = randi() % (a.get_width()) + a.get_left()
		x2 = randi() % (b.get_width()) + b.get_left()
		y1 = randi() % (b.get_top() - a.get_bottom()) + a.get_bottom()
		y2 = y1
	elif direction == "horizontal":
		y1 = randi() % (a.get_height()) + a.get_top()
		y2 = randi() % (b.get_height()) + b.get_top()
		x1 = randi() % (b.get_left() - a.get_right()) + a.get_right()
		x2 = x1
	return {
		'x1': x1,
		'x2': x2,
		'y1': y1,
		'y2': y2
	}
	
func _connect_points(a: Room, b: Room, points: Dictionary, direction: String):
	var min_x = min(points.x1, points.x2)
	var max_x = max(points.x1, points.x2)
	var min_y = min(points.y1, points.y2)
	var max_y = max(points.y1, points.y2)
	
	for i in range(min_x, max_x + 1):
		dungeon[points.y1][i] = 1
		dungeon[points.y2][i] = 1
	for i in range(min_y, max_y  + 1):
		dungeon[i][points.x1] = 1
		dungeon[i][points.x2] = 1
		
	if direction == "vertical":
		for i in range(a.get_bottom(), points.y1 + 1):
			dungeon[i][points.x1] = 1
		for i in range(points.y1, b.get_top()):
			dungeon[i][points.x2] = 1
	if direction == "horizontal":
		for i in range(a.get_right(), points.x1 + 1):
			dungeon[points.y1][i] = 1
		for i in range(points.x1, b.get_left()):
			dungeon[points.y2][i] = 1

	
func _create_corridor_between(a: Room, b: Room, direction: String):
	var points = _select_collinear_points_parallel_to(a, b, direction)
	_connect_points(a, b, points, direction)
	
func _merge_rooms(a: Room, b: Room):
	var min_x = min(a.get_left(), b.get_left())
	var max_x = max(a.get_right(), b.get_right())
	var min_y = min(a.get_top(), b.get_top())
	var max_y = max(a.get_bottom(), b.get_bottom())
	
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			dungeon[y][x] = 1
	
func _connect_rooms():
	for i in _N:
		for j in _M:
			var room = rooms[i][j]
			if i > 0:
				if randf() < 0.05:
					_merge_rooms(rooms[i-1][j], room)
				else:
					_create_corridor_between(rooms[i-1][j], room, "vertical")
			if j > 0:
				if randf() < 0.05:
					_merge_rooms(rooms[i][j-1], room)
				else:
					_create_corridor_between(rooms[i][j-1], room, "horizontal")
		
func _create_dead_ends(density: int):
	pass
	
func _place_doors():
	pass
	
func _set_up_terrain():
	pass
	
func _clean_up():
	pass
	
func _place_items(density: int):
	pass
	
func _place_burried_items(density: int):
	pass
	
func _place_special_tiles(density: int):
	pass
