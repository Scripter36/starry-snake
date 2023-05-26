extends Node

var snake: Array[Vector2i]
var snake_head: Vector2i
var movement: Vector2i
var new_movement: Vector2i
var apple: Vector2i

var snake_history: Array[Array]
var prev_snake_history: Array[Array]

var stars: Dictionary = {}

@onready var GRID_SIZE = $Scene.grid_size

var accept_input = true
var game_ready = false

# Called when the node enters the scene tree for the first time.
func new_game():
	snake_head = Vector2i(GRID_SIZE / 2, GRID_SIZE / 2)
	snake.clear()
	snake.push_back(snake_head)
	movement = Vector2i(1, 0)
	new_movement = Vector2i(0, 0)
	snake_history = []
	new_apple()
	update_grid()
	
	game_ready = true
	accept_input = false
	await get_tree().create_timer(1.0).timeout
	accept_input = true

func game_over():
	print("You lose!")
	prev_snake_history = snake_history.duplicate(true)
	snake_history = []
	$Timer.stop()
	new_game()

func new_apple():
	apple = Vector2i(randi_range(0, GRID_SIZE - 1), randi_range(0, GRID_SIZE - 1))
	while apple in snake:
		apple = Vector2i(randi_range(0, GRID_SIZE - 1), randi_range(0, GRID_SIZE - 1))
	
	if snake_history.size() > 0 and snake_history.size() <= prev_snake_history.size():
		var cur_trail = snake_history[snake_history.size() - 1]
		var prev_trail = prev_snake_history[snake_history.size() - 1]
		for p in cur_trail:
			if p in prev_trail:
				if p in stars:
					stars[p] += 1
				else:
					stars[p] = 1
				break
		
	snake_history.push_back([])
	
func _ready():
	new_game()

func _unhandled_input(event):
	if not accept_input:
		return
		
	# start the game when any key is pressed
	if game_ready and event is InputEventKey:
		$Timer.start()
		game_ready = false
		
	if event.is_action_pressed("move_left"):
		new_movement = Vector2i(-1, 0)
	elif event.is_action_pressed("move_right"):
		new_movement = Vector2i(1, 0)
	elif event.is_action_pressed("move_up"):
		new_movement = Vector2i(0, -1)
	elif event.is_action_pressed("move_down"):
		new_movement = Vector2i(0, 1)
	
func _on_timer_timeout():
	if (new_movement.x != 0 or new_movement.y != 0) and \
		(snake.size() == 1 or (new_movement.x != -movement.x and new_movement.y != -movement.y)):
		movement = new_movement
	
	snake_head += movement
	if snake_head.x == -1 or snake_head.x == GRID_SIZE or snake_head.y == -1 or snake_head.y == GRID_SIZE or snake_head in snake:
		game_over()
		return
	
	if snake_head == apple:
		new_apple()
	else:
		snake.pop_front()
	
	snake.push_back(snake_head)
	snake_history[snake.size() - 1].push_back(snake_head)
	update_grid()
			
func update_grid():
	$Scene.reset()

	if snake.size() > 0 and snake.size() < prev_snake_history.size():
		for pos in prev_snake_history[snake.size() - 1]:
			$Scene.set_color(pos.x, pos.y, Color(0.15, 0.15, 0.15))
		for pos in snake_history[snake.size() - 1]:
			$Scene.set_color(pos.x, pos.y, Color(0.15, 0.15, 0.15))
			
	for p in stars:
		var v : float = clamp(0.2 * stars[p], 0.0, 1.0)
		$Scene.set_color(p.x, p.y, Color(v, v, 0))

	for pos in snake:
		$Scene.set_color(pos.x, pos.y, Color(1.0, 1.0, 1.0))
		
	$Scene.set_color(apple.x, apple.y, Color(1.0, 0.5, 0.5))
	
	# $Scene.reset()
	# for i in range(20):
	# 	var v = 0.2 * randi_range(1, 5)
	# 	$Scene.set_color(randi_range(0, 19), randi_range(0, 19), Color(v, v, 0))
