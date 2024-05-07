extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_R):
		var old_gen = get_child(0)
		var w = old_gen.width
		var h = old_gen.height
		old_gen.free()
		var gen = preload("res://generatore_livello.tscn").instantiate()
		gen.width = w
		gen.height = h
		add_child(gen)
