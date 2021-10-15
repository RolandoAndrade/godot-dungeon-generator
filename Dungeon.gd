extends Node2D

onready var tilemap: TileMap = $TileMap
var root: Three
var container: ThreeContainer

func _ready():
	randomize()
	create_dungeon()

func create_dungeon():
	tilemap.clear()
	container = ThreeContainer.new(Rect2(Vector2(0,0), Vector2(100,100)))
	root = Three.new(container, 5, tilemap)
	tilemap.update_bitmask_region()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		create_dungeon()
