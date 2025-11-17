extends Sprite2D
@onready var sprite_colour_ramp = texture.color_ramp
@export var seed = 0
var resolution = 16
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
	texture.color_ramp = generated_gradient

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	resolution = $"../PatternResolutionInput/HSlider".value
	resolution = 2 ** resolution
	$"../PatternResolutionInput/Label2".text = "Current Resolution: " + str(resolution) + " px"
	var scale_mult = 16*32/resolution
	visible = false
	scale = Vector2(scale_mult,scale_mult)
	texture.noise.seed = int($"../SeedInput/TextEdit".text)
	texture.noise.frequency = (16.0/(100*resolution))
	texture.width = resolution
	texture.height = resolution
	visible = true

	pass


func _on_button_pressed() -> void:
	var tex := texture
	var img := tex.get_image()
	var downloads_path = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
	print(downloads_path)
# Save the image there
	img.save_png(downloads_path + "/export.png")
