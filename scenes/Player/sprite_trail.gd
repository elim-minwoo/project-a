extends Node

@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var player: CharacterBody2D = $".."

var spriteArray: Array[AnimatedSprite2D]

func _ready() -> void:
	SetupSpriteArray()

func SetupSpriteArray():
	for i in 10:
		var newSprite : AnimatedSprite2D = animated_sprite_2d.duplicate()
		newSprite.stop()
		newSprite.z_index = 0
		newSprite.modulate.a = 0
		get_tree().root.add_child.call_deferred(newSprite)
		spriteArray.append(newSprite)

func _process(delta: float) -> void:
	
	if player.velocity.x == 0:
		return
	
	if (get_tree().get_frame() % 6) == 0:
		if spriteArray.is_empty() == false:
			var sprite: AnimatedSprite2D = spriteArray.pop_front() as AnimatedSprite2D
			sprite.animation = animated_sprite_2d.animation
			sprite.frame = animated_sprite_2d.frame
			
			sprite.global_position = player.global_position + animated_sprite_2d.position
			sprite.StartFading()
			
			await get_tree().create_timer(0.0).timeout
			spriteArray.append(sprite)
