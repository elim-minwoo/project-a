extends RigidBody2D

@export var projectile_node : PackedScene

func shoot():
	var projectile = projectile_node.instantiate()
	projectile.position = position
	get_parent().add_child(projectile)
