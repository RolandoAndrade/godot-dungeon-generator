class_name Three

var container: ThreeContainer
var a_child: Three
var b_child: Three

func _init(container: ThreeContainer, level: int, tilemap: TileMap):
	self.container = container
	if level > 0:
		_split(container, level, tilemap)
	else:
		_create_room(container, tilemap)
		
func _split(container: ThreeContainer, level: int, tilemap: TileMap):
	var a_container: ThreeContainer
	var b_container: ThreeContainer
	var containers = container.split()
	a_container = containers[0]
	b_container = containers[1]
	a_child = get_script().new(a_container, level - 1, tilemap)
	b_child = get_script().new(b_container, level - 1, tilemap)
	
func _create_room(container: ThreeContainer, tilemap: TileMap):
	var margin_left = randi() % 5
	var margin_right = randi() % 5
	var margin_top = randi() % 5
	var margin_bottom = randi() % 5
	var x = container.area.position.x
	var y = container.area.position.y
	var w = container.area.size.x
	var h = container.area.size.y
	for i in range(x + margin_left, x + w - margin_right):
		for j in range(y + margin_top, y + h - margin_bottom):
			tilemap.set_cell(i, j, 0)
	
