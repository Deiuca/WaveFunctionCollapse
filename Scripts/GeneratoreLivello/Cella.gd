extends Node2D
class_name Cella

#Pattern: SuSx, Su, SuDx, Sx, Dx, GiuSx, Giu, GiuDx
var vicini = [null,null,null,null,null,null,null,null] #TODO  basta vocinato ridotto

var fisso = false

var preFab : PreFab = preload("res://prefab.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(self.preFab)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_prefab(prefab : PreFab, fissa = false):
	if not self.fisso:
		get_child(0).free()
		self.preFab = prefab.duplicate()
		self.preFab.centered = false
		self.preFab.position = Vector2(0,0)
		add_child(self.preFab)
		self.fisso = fissa

func get_bordi()-> Array: 
	return preFab.bordi
	
func compatibilita()-> Array:
	
	var result = []
	#Sopra
	var sopra = self.vicini[1].get_bordi()[3] if self.vicini[1] != null else ""
	result.append(sopra)
	#Sx
	var sx = self.vicini[3].get_bordi()[2] if self.vicini[3] != null else ""
	result.append(sx)
	#Dx
	var dx = self.vicini[4].get_bordi()[1] if self.vicini[4] != null else ""
	result.append(dx)
	#Sotto
	var sotto = self.vicini[6].get_bordi()[0] if self.vicini[6] != null else ""
	result.append(sotto)
	
	return result
