extends Node

var main_scene: Node

var ui_layer: LoadableLayer
var game_layer: LoadableLayer

var game_node: Node2D

var player_dir : int = 0

var flash_visible: ScreenFlash
var is_parrying : bool = false

var camera: Camera2D

signal screen_shock(position: Vector2)
