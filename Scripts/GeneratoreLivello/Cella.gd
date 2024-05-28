extends Node2D
class_name Cella

#Pattern: SuSx, Su, SuDx, Sx, Dx, GiuSx, Giu, GiuDx
#Pattern: Su, Sx, Dx, Giu
var vicini = [null,null,null,null] 

var collassata = false

var preFab : PreFab = preload("res://prefab.tscn").instantiate()

var debug_nome = self.preFab.name

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(self.preFab)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_prefab(prefab : PreFab):
	if not self.collassata:
		self.preFab = prefab.duplicate()
		self.preFab.centered = false
		self.preFab.position = Vector2(0,0)
		add_child(self.preFab)
		self.collassata = true
		#Debug
		debug_nome = self.preFab.name

func get_bordi()-> Array: 
	return preFab.bordi
	
func compatibilita()-> Array:
	
	var result = []
	#Sopra
	var sopra = self.vicini[0].get_bordi()[3] if self.vicini[0] != null else ""
	result.append(sopra)
	#Sx
	var sx = self.vicini[1].get_bordi()[2] if self.vicini[1] != null else ""
	result.append(sx)
	#Dx
	var dx = self.vicini[2].get_bordi()[1] if self.vicini[2] != null else ""
	result.append(dx)
	#Sotto
	var sotto = self.vicini[3].get_bordi()[0] if self.vicini[3] != null else ""
	result.append(sotto)
	
	return result
