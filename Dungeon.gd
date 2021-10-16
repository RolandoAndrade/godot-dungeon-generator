extends Node2D

onready var tilemap: TileMap = $TileMap
var root: Three
var container: ThreeContainer

func _ready():
	randomize()
	create_dungeon_2()

func create_dungeon2():
	tilemap.clear()
	container = ThreeContainer.new(Rect2(Vector2(0,0), Vector2(100,100)))
	root = Three.new(container, 5, tilemap)
	tilemap.update_bitmask_region()

func create_dungeon_2():
	tilemap.clear()
	var M = ((randi() % 3) + 1) * 3
	var d = StandardDungeonGenerator.new(Vector2(M,M*2/3))
	var rooms = randi() % (M * M * 2 / 3 + 1)
	d.generate_dungeon(Rect2(0,0,54,32), rooms)
	var dungeon = d.dungeon
	for i in range(len(dungeon)):
		for j in range(len(dungeon[i])):
			if dungeon[i][j] == 1:
				tilemap.set_cell(j, i, 0)
	tilemap.update_bitmask_region()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		create_dungeon_2()
