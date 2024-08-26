extends PointLight2D

# Exported variable to control the flicker speed
@export var flicker_speed: float = 0.05

# Exported variables to control the range of energy and radius fluctuations
@export var energy_variation: float = 0.01
@export var scale_variation: float = 0.01

# Internal timer to track the flicker interval
var _flicker_timer: float = 0.0
var _initial_scale: float;

func _ready() -> void:
	_initial_scale = texture_scale


func _process(delta: float) -> void:
	# Update the timer
	_flicker_timer += delta

	# Check if it's time to flicker
	if _flicker_timer >= flicker_speed:
		# Randomize the energy and radius to simulate flicker
		energy = 1.0 + randf() * energy_variation - (energy_variation / 2)
		texture_scale = _initial_scale + (randf() * scale_variation - (scale_variation / 2))

		# Reset the flicker timer
		_flicker_timer = 0.0
