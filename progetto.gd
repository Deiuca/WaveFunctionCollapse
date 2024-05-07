extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_R):
		get_child(0).free()
		var gen = preload("res://generatore_livello.tscn").instantiate()
		add_child(gen)
