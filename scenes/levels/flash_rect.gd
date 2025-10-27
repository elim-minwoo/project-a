extends ColorRect


var material: Material
var shader: Shader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.flash_visible = self
	
	
func set_flash():
	
