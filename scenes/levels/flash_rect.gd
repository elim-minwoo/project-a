extends ColorRect
class_name ScreenFlash

var flash: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.flash_visible = self
	
func _process(delta: float) -> void:
	pass
	
func set_flash(flash_amm):
	flash = flash_amm
	material.set_shader_parameter("flash", flash)
	
