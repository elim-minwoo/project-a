extends Node2D

@onready var player_sprite: AnimatedSprite2D = $"../PlayerSprite"
@onready var player: CharacterBody2D = $".."

var spriteArray: Array[AnimatedSprite2D] = []
var trail_active := false

var trail_divide = 1
var trail_number = 20

func _ready() -> void:
	SetupSpriteArray()

func SetupSpriteArray():
	for i in trail_number:
		var newSprite : AnimatedSprite2D = player_sprite.duplicate()
		newSprite.stop()
		newSprite.z_index = -1
		newSprite.modulate.a = 0
		Global.game_node.add_child.call_deferred(newSprite)
		spriteArray.append(newSprite)

func activate_trail(t_divide, t_number) -> void:
	if trail_active:
		return
	trail_divide = t_divide
	trail_number = t_number
		
	trail_active = true
	await get_tree().create_timer(0.11, false, true).timeout
	trail_active = false

func _physics_process(delta: float) -> void:
	
	if !trail_active:
		return
	elif player.velocity.x == 0 and player.is_on_floor():
		return
	 
	if (Engine.get_physics_frames() % trail_divide) == 0:
		if spriteArray.is_empty() == false:
			var sprite: AnimatedSprite2D = spriteArray.pop_front()
			sprite.animation = player_sprite.animation
			sprite.flip_h = player_sprite.flip_h
			sprite.frame = player_sprite.frame
			sprite.global_position = player.global_position + player_sprite.position
			sprite.StartFading()
			spriteArray.append(sprite)
