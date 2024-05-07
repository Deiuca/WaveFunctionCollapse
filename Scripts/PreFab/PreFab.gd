extends Sprite2D
class_name PreFab

@export var soffitto : Componente
@export var componenti : Array[Componente]
@export var pavimento : Componente 
@export var priorita = 0

#Su, Sx, Dx, Giu
@export var bordi = [ "", "", "", "" ]

# Called when the node enters the scene tree for the first time.
func _ready():
	aggiorna_bordi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func aggiorna_bordi():
	if self.bordi == ["","","",""]:
		if self.soffitto != null:
			self.bordi = somma_bordi(self.bordi, self.soffitto.bordi)
		if self.pavimento != null:
			self.bordi = somma_bordi(self.bordi, self.pavimento.bordi)
		for componente in self.componenti:
			self.bordi = somma_bordi(self.bordi, self.componente.bordi)

func somma_bordi(bordi: Array, bordi2: Array) -> Array:
	var result = []
	for i in range(bordi.size()):
		if not bordi.has(bordi2[i]):
			result.append(bordi[i]+bordi2[i])
		else:
			result.append(bordi[i])
	return result

func ritorna_inverso_flip_h(nameAdd = "_Flip") ->PreFab:
	var copia = self.duplicate()
	copia.flip_h = true
	for c in copia.get_children():
		c.flip_h = true
	copia.bordi = [self.bordi[0],self.bordi[2],self.bordi[1],self.bordi[3]]
	copia.name = copia.name + nameAdd
	return copia
