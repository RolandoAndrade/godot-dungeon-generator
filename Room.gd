class_name Room

var area: Rect2

func _init(area: Rect2):
	self.area = area

func get_top():
	return int(area.position.y)
	
func get_bottom():
	return int(area.position.y + area.size.y)
	
func get_left():
	return int(area.position.x)
	
func get_right():
	return int(area.position.x + area.size.x)
	
func get_width():
	return int(area.size.x)
	
func get_height():
	return int(area.size.y)


func get_center():
	return Vector2(get_left()+int(area.size.x/2),
	get_top() + int(area.size.y/2))
