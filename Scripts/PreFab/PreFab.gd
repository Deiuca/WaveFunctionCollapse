extends Sprite2D
class_name PreFab

#Su, Sx, Dx, Giu
@export var bordi = [ "", "", "", "" ]
@export var peso = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ritorna_inverso_flip_h(nameAdd = "_Flip") ->PreFab:
	var copia = self.duplicate()
	copia.flip_h = true
	for c in copia.get_children():
		c.flip_h = true
	copia.bordi = [self.bordi[0],self.bordi[2],self.bordi[1],self.bordi[3]]
	copia.name = copia.name + nameAdd
	return copia

func ritorna_inverso_flip_v(nameAdd = "_Flip") ->PreFab:
	var copia = self.duplicate()
	copia.flip_v = true
	for c in copia.get_children():
		c.flip_v = true
	copia.bordi = [self.bordi[0],self.bordi[2],self.bordi[1],self.bordi[3]]
	copia.name = copia.name + nameAdd
	return copia
