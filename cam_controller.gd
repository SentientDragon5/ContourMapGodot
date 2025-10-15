extends Camera2D

@export var speed: float = 400.0
@export var smoothing_speed: float = 5.0
@export var zoom_speed: float = 5.0
@export var zoom_levels: Array[float] = [0.5, 0.75, 1.0, 1.5, 2.0]

var current_zoom_index: int = 2
var target_zoom: Vector2 = Vector2.ONE
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	target_position = position
	if zoom_levels.size() > 0:
		current_zoom_index = clamp(current_zoom_index, 0, zoom_levels.size() - 1)
		var initial_zoom_value = zoom_levels[current_zoom_index]
		target_zoom = Vector2(initial_zoom_value, initial_zoom_value)
		zoom = target_zoom

func _process(delta: float) -> void:
	var move_vector = Input.get_vector("left", "right", "up", "down")
	target_position += move_vector * speed * Vector2(1/target_zoom.x,1/target_zoom.y) * delta
	
	position = lerp(position, target_position, smoothing_speed * delta)

	if Input.is_action_just_pressed("zoom_in"):
		current_zoom_index = clamp(current_zoom_index + 1, 0, zoom_levels.size() - 1)
		var new_zoom = zoom_levels[current_zoom_index]
		target_zoom = Vector2(new_zoom, new_zoom)
		
	if Input.is_action_just_pressed("zoom_out"):
		current_zoom_index = clamp(current_zoom_index - 1, 0, zoom_levels.size() - 1)
		var new_zoom = zoom_levels[current_zoom_index]
		target_zoom = Vector2(new_zoom, new_zoom)

	zoom = lerp(zoom, target_zoom, zoom_speed * delta)
