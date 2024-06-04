extends Node2D


@export var width = 5
@export var height = 5

@export var generator_seed : int = randi() % 3000

var tipi_celle : Array[Node] = []

@export var dim_txture : Vector2 = Vector2(20,20)

var randomGenerator : RandomNumberGenerator = RandomNumberGenerator.new()

var celle : Array[Cella] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Determina il seed del Generatore di mondo
	self.randomGenerator.seed = self.generator_seed
	
	#DEBUG
	print("Random Seed: " + str(generator_seed))
	
	#Crea Prefab inversi
	#$Prefab_Utilizzati.add_child($Prefab_Utilizzati/Soffitto_Entrata.ritorna_inverso_flip_h("_Dx"))
	
	#Duplica i prefab in base al loro peso
	for pref in $Prefab_Utilizzati.get_children():
		for i in range(pref.peso-1):
			$Prefab_Utilizzati.add_child(pref.duplicate())
	
	#Determina la scala delle Celle in base alla dimensione delle texture
	var windows_size = get_viewport().size
	var cell_scale = Vector2((windows_size.x/dim_txture.x)/self.width, (windows_size.y/dim_txture.y)/self.height)
	
	#Popolo array Celle e set posizioni
	for ih in range(self.height):
		for iw in range(self.width):
			var istanza = Cella.new()
			istanza.debug_numero = (ih+1)*(iw+1)
			istanza.position = Vector2(iw*dim_txture.x*cell_scale.x, ih*dim_txture.y*cell_scale.y)
			istanza.scale = cell_scale
			self.celle.append(istanza)
			add_child(istanza)
			
	#A ogni istanza nell'array di celle vengono definiti i suoi vicini
	for indx in range(self.celle.size()):
		var cella = self.celle[indx]      #Cella corrente
		#Pattern: Su, Sx, Dx, Giu, SuSx, SuDx, GiuDx, GiuSx
		#Sx
		if (indx-1) >= 0 and (indx-1)/self.width == indx/self.width:
			cella.vicini[1] = self.celle[indx-1]
		#Dx
		if (indx+1) < self.celle.size() and (indx+1)/self.width == indx/self.width:
			cella.vicini[2] = self.celle[indx+1]
		#Su
		if (indx-self.width) >= 0:
			cella.vicini[0] = self.celle[indx-self.width]
		#Giu
		if (indx+self.width) < self.celle.size():
			cella.vicini[3] = self.celle[indx+self.width]
		## Vicinato aggiuntivo
		#SuSx
		if(indx-(self.width+1)) >= 0:
			cella.vicini[4] = self.celle[indx-self.width].vicini[2]
		#SuDx
		if ((indx-(self.width-1))/self.width) != indx/self.width:
			cella.vicini[5] = self.celle[indx-self.width].vicini[1]
		#GiuSx
		if (indx+(self.width-1)) < self.celle.size() and ((indx+(self.width-1))/self.width) != indx/self.width:
			cella.vicini[7] = self.celle[indx+(self.width-1)]
		#GiuDx
		if (indx+(self.width)) < self.celle.size() and (indx+(self.width))/self.width == (indx+(self.width+1))/self.width:
			cella.vicini[6] = self.celle[indx+(self.width+1)]
	
	#Collassa Pavimento
	for e in range((self.width*self.height)-self.width, (self.width*self.height)):
		self.celle[e].set_prefab($Prefab_Utilizzati/Bedrock)
	$Prefab_Utilizzati/Bedrock.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var counter = 0
var iterazioni = 1
func _process(delta):
	var cella_da_collassare = trova_cella_meno_entropia()
	while cella_da_collassare != null:
		var compatibili = ritorna_compatibili(cella_da_collassare)
		cella_da_collassare.set_prefab(compatibili[ randomGenerator.randi_range(0, compatibili.size()-1)])
		cella_da_collassare = trova_cella_meno_entropia()

func trova_cella_meno_entropia():
	var cella_minima = [$Prefab_Utilizzati.get_child_count(), null]
	for c in self.celle:
		if not c.collassata:
			var entropia = ritorna_compatibili(c).size()
			if  entropia <= cella_minima[0]:
				cella_minima = [entropia,c]
	return cella_minima[1]

func ritorna_compatibili(cella : Cella) -> Array:
	if not cella.collassata:
		var compatibilita = cella.compatibilita()
		var compatibili = []
		for pref in $Prefab_Utilizzati.get_children():
			var eGiusto = true
			var testbordi = pref.bordi
			for i in range(pref.bordi.size()):
				if (compatibilita[i] != "" and pref.bordi[i] != ""):
					eGiusto = eGiusto && (contiene_almeno_un_carattere(compatibilita[i], pref.bordi[i]))
					if !eGiusto:
						break
			if eGiusto:
				compatibili.append(pref)
		return compatibili if not compatibili.is_empty() else [cella.preFab]
	return [cella.preFab]

#Funzioni Helpers:
func contiene_almeno_un_carattere(una_stringa: String, altra_stringa: String) -> bool:
	for carattere in una_stringa:
		if carattere in altra_stringa:
			return true  
	return false  

