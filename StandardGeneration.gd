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

func _create_room(top: int, left: int, max_width: int, max_height: int):
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
			
func _create_dummy_room(top: int, left: int, max_width: int, max_height: int):
	var x = max_width / 2 + left
	var y = max_height / 2 + top
	dungeon[y][x] = 1
	
func _place_rooms(width: int, height: int, density: int):
	var room_max_width = int(width / _M)
	var room_max_height = int(height / _N)
	var number_of_rooms = _get_number_of_rooms(density)
	var number_of_dummy_rooms = _M * _N - number_of_rooms 
	var rooms_order = _get_rooms_order(number_of_rooms, number_of_dummy_rooms)
	for i in _N:
		for j in _M:
			var room_type = rooms_order[i * _M + j]
			match room_type:
				TypeOfRoom.ROOM:
					_create_room(i * room_max_height, j * room_max_width,
					room_max_width, room_max_height)
				TypeOfRoom.DUMMY_ROOM:
					_create_dummy_room(i * room_max_height, j * room_max_width,
					room_max_width, room_max_height)
	
func _connect_rooms():
	for i in _M:
		for j in _N:
			pass
		
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
