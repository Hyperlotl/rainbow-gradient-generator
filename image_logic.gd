extends Node2D
@export var seed = 0
@onready var display = $"generatedPatternDisplay"
@onready var generated_noise = $generatedPattern
@onready var sprite_colour_ramp = generated_noise.texture.color_ramp

var resolution = 64
var colours = [
	Color(0,0,1,1),
	Color(0,1,1,1),
	Color(0,1,0,1),
	Color(1,1,0,1),
	Color(1,0,0,1),
	Color(1,0,1,1),
	Color(0,0,1,1),
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var generated_gradient = Gradient.new()
	var offsets = []
	for i in range(0,7):
		offsets.append(float(i)/6)
	generated_gradient.offsets = PackedFloat32Array(offsets)
	generated_gradient.colors =	PackedColorArray(colours)	
	generated_noise.texture.color_ramp = generated_gradient

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	resolution = $PatternResolutionInput/HSlider.value
	resolution = 2 ** resolution
	$"PatternResolutionInput/Label2".text = "Current Resolution: " + str(resolution) + " px"
	var scale_mult = 16*32/resolution
	generated_noise.texture.noise.seed = int($"SeedInput/TextEdit".text)
	generated_noise.texture.noise.frequency = (16.0/(100*resolution))
	generated_noise.texture.width = resolution
	generated_noise.texture.height = resolution
	display.scale = Vector2(scale_mult,scale_mult)
	display.texture = ImageTexture.create_from_image(generated_noise.texture.get_image())
	print("If the code is running correctly, this should display 0: "+str(display.texture.get_width()-resolution))


func _on_button_pressed() -> void:
	var img = generated_noise.texture.get_image()
	var downloads_path = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
	img.save_png(downloads_path + "/export.png")
