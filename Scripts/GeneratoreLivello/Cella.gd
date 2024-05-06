extends Node2D
class_name Cella

#Pattern: SuSx, Su, SuDx, Sx, Dx, GiuSx, Giu, GiuDx
var vicini = [null,null,null,null,null,null,null,null]

var preFab : PreFab = preload("res://prefab.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(self.preFab)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_prefab(prefab : PreFab):
	get_child(0).queue_free()
	self.preFab = prefab.duplicate()
	self.preFab.centered = false
	self.preFab.position = Vector2(0,0)
	add_child(self.preFab)
