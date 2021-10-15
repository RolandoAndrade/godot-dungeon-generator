class_name DungeonStrategy

var dungeon: Array = []

func _clear_dungeon(width: int, height: int):
	for i in height:
		var row = []
		for j in width:
			row.append(0)
		dungeon.append(row)

func _place_rooms(width: int, height: int, density: int):
	pass
	
func _connect_rooms():
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

func generate_dungeon(area: Rect2, 
room_density: int = -1,
dead_ends_density: int = -1,
terrain_density: int = -1,
items_density: int = -1,
burried_items_density: int = -1,
special_tiles_density: int = -1):
	var width = int(area.size.x)
	var height = int(area.size.y)
	_clear_dungeon(width, height)
	_place_rooms(width, height, room_density)
	_connect_rooms()
	_create_dead_ends(dead_ends_density)
	_place_doors()
	_set_up_terrain()
	_clean_up()
	_place_items(items_density)
	_place_burried_items(burried_items_density)
	_place_special_tiles(special_tiles_density)
	
