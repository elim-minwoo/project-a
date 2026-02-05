extends Node

@onready var player_sprite: AnimatedSprite2D = $"../PlayerSprite"
@onready var player: CharacterBody2D = $".."

var spriteArray : Array[AnimatedSprite2D] = []
var trail_active := false

func _ready() -> void:
	SetupSpriteArray()



func SetupSpriteArray():
	for i in 20:
		var newSprite : AnimatedSprite2D = player_sprite.duplicate()
		newSprite.stop() # newSprite = new animatedsprite2d
		newSprite.z_index = -1
		newSprite.modulate.a = 0
		Global.game_node.add_child.call_deferred(newSprite) # add child to game screen not root
		spriteArray.append(newSprite)



func trail_effect() -> void:
	if trail_active:
		return
	
	trail_active = true
	await get_tree().create_timer(0.1, false, true).timeout
	trail_active = false



func _physics_process(delta: float) -> void:
	if !trail_active:
		return
	elif player.velocity.x == 0 and player.is_on_floor():
		return
	
	# divide current frame number by 6 and when this = 0 (every 6 frames), create new sprite 
	if (Engine.get_physics_frames() % 1) == 0:
		if spriteArray.is_empty() == false:
			var sprite : AnimatedSprite2D = spriteArray.pop_front()
			sprite.animation = player_sprite.animation
			sprite.flip_h = player_sprite.flip_h
			sprite.frame = player_sprite.frame
			
			sprite.global_position = player.global_position + player_sprite.position
			sprite.StartFading()
			
			spriteArray.append(sprite)
