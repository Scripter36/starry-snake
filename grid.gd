extends Control

class_name Grid

var grid_data: Array[Color] = []

const GRID_SIZE: int = 16
const GRID_WIDTH: float = 64.0
const GRID_MARGIN: float = 8.0

func reset():
	for j in range(GRID_SIZE):
		for i in range(GRID_SIZE):
			set_color(i, j, Color(0, 0, 0))
	
func _ready():
	grid_data.resize(GRID_SIZE * GRID_SIZE)
	reset()

func _draw():
	for j in range(GRID_SIZE):
		for i in range(GRID_SIZE):
			draw_rect(Rect2(GRID_WIDTH * i + GRID_MARGIN/2, GRID_WIDTH * j + GRID_MARGIN/2, \
							GRID_WIDTH - GRID_MARGIN, GRID_WIDTH - GRID_MARGIN), get_color(i, j), true)
	
func get_color(x: int, y: int) -> Color:
	return grid_data[GRID_SIZE * y + x]
	
func set_color(x: int, y: int, value: Color):
	grid_data[GRID_SIZE * y + x] = value
