extends Node

var main_scene: Node

var ui_layer: LoadableLayer
var game_layer: LoadableLayer

var game_node: Node2D

var player_dir : int = 0


var camera: Camera2D

var konami_on := false

signal screen_shock(screen_size: Vector2)
signal shockwave_finish
signal code_completed
