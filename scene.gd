@tool
extends Node

class_name Scene

@export var led_scene: PackedScene

var grid_data: Array[Color] = []

@export var grid_size: int = 20:
	set(size):
		if size != grid_size:
			grid_size = size
			reset()

@export var grid_width: float = 48.0:
	set(width):
		if width != grid_width:
			grid_width = width
			reset()

func reset():
	var led_root = get_node("BackWall/LEDs")
	grid_data.resize(grid_size * grid_size)
	for j in range(grid_size):
		for i in range(grid_size):
			set_color(i, j, Color(0, 0, 0))

	var old_leds = led_root.get_children()
	for led in old_leds:
		led.queue_free()
	var new_leds = []
	for j in range(grid_size):
		for i in range(grid_size):
			var led = led_scene.instantiate()
			led.position = Vector3(grid_width * (i - grid_size / 2.0 + 0.5), 0, grid_width * (j - grid_size / 2.0 + 0.5))
			# led.color = get_color(i, j)
			led_root.add_child(led)
			led.set_owner(get_tree().edited_scene_root)
			new_leds.append(led)
	
func _ready():
	reset()

func get_color(x: int, y: int) -> Color:
	return grid_data[grid_size * y + x]
	
func set_color(x: int, y: int, value: Color):
	grid_data[grid_size * y + x] = value
