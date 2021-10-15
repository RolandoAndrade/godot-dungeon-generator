class_name ThreeContainer

var area: Rect2

const MIN_SIZE = 1

func _init(area: Rect2):
	self.area = area

func split():
	var space_a: ThreeContainer
	var space_b: ThreeContainer
	if _is_split_vertical():
		var cls = get_script()
		var new_width: int = fmod(randi(), self.area.size.x + 1) 
		space_a = cls.new(Rect2(
			area.position,
			Vector2(new_width, self.area.size.y)
		))
		space_b = cls.new(Rect2(
			area.position + Vector2(new_width, 0),
			Vector2(self.area.size.x  - new_width, 
			self.area.size.y)
		))
	else:
		var cls = get_script()
		var new_height: int = fmod(randi(), self.area.size.y + 1) 
		space_a = cls.new(Rect2(
			area.position,
			Vector2(self.area.size.x, new_height)
		))
		space_b = cls.new(Rect2(
			area.position + Vector2(0, new_height),
			Vector2(self.area.size.x, 
			self.area.size.y - new_height)
		))
	return [space_a, space_b]
	

func _is_split_vertical():
	return randf() < 0.5
