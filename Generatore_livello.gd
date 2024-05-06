extends Node2D


@export var width = 10
@export var height = 10

@export var generator_seed : int = randi() % 3000

var tipi_celle : Array[Node] = []

@export var dim_txture : Vector2 = Vector2(20,20)

var randomGenerator : RandomNumberGenerator = RandomNumberGenerator.new()

var celle = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Determina il seed del Generatore di mondo
	self.randomGenerator.set_seed(self.generator_seed)
	
	#DEBUG
	print(generator_seed)
	
	#Recupera PreFab
	tipi_celle = $Prefab_Utilizzati.get_children()
	
	#Crea Prefab inversi
	$Prefab_Utilizzati.add_child($Prefab_Utilizzati/Room_Entrace.ritorna_inverso_flip_h("_Dx"))
	$Prefab_Utilizzati.add_child($Prefab_Utilizzati/Room_Alta_Entrace.ritorna_inverso_flip_h("_Dx"))
	
	#Determina la scala delle Celle in base alla dimensione delle texture
	
	var windows_size = get_viewport().size
	var cell_scale = Vector2((windows_size.x/dim_txture.x)/self.width, (windows_size.y/dim_txture.y)/self.height)
	
	#Popolo array Celle e set posizioni
	for ih in range(self.height):
		for iw in range(self.width):
			var istanza = Cella.new()
			istanza.position = Vector2(iw*dim_txture.x*cell_scale.x, ih*dim_txture.y*cell_scale.y)
			istanza.scale = cell_scale
			self.celle.append(istanza)
			add_child(istanza)
			
	#A ogni istanza nell'array di celle vengono definiti i suoi vicini
	for indx in range(self.celle.size()):
		var cella = self.celle[indx]      #Cella corrente
		#Pattern: SuSx, Su, SuDx, Sx, Dx, GiuSx, Giu, GiuDx
		#Sx
		if (indx-1) >= 0:
			cella.vicini[3] = self.celle[indx-1]
		#Dx
		if (indx+1) < self.celle.size() and (indx+1)/self.width == indx/self.width:
			cella.vicini[4] = self.celle[indx+1]
		#Su
		if (indx-self.width) >= 0:
			cella.vicini[1] = self.celle[indx-self.width]
		#Giu
		if (indx+self.width) < self.celle.size():
			cella.vicini[6] = self.celle[indx+self.width]
		#SuSx
		if(indx-(self.width+1)) >= 0:
			cella.vicini[0] = self.celle[indx-(self.width+1)]
		#SuDx
		if ((indx-(self.width-1))/self.width) != indx/self.width:
			cella.vicini[2] = self.celle[indx-(self.width-1)]
		#GiuSx
		if (indx+(self.width-1)) < self.celle.size() and ((indx+(self.width-1))/self.width) != indx/self.width:
			cella.vicini[5] = self.celle[indx+(self.width-1)]
		#GiuDx
		if (indx+(self.width)) < self.celle.size() and (indx+(self.width))/self.width == (indx+(self.width+1))/self.width:
			cella.vicini[7] = self.celle[indx+(self.width+1)]
	
	#Collassa at random in pavimento
	for i in range(0, 8):
		var randIndx = randomGenerator.randi_range(self.width, (self.width*self.height)-self.width)
		self.celle[randIndx].set_prefab($Prefab_Utilizzati/Pavimento)
		
	#Collassa Pavimento
	for e in range((self.width*self.height)-self.width, (self.width*self.height)):
		self.celle[e].set_prefab($Prefab_Utilizzati/Pavimento_Alto)
		
	print(compara_str_by_caratteri("ACCE", "EACC"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
var counter = 0
var iterazioni = 10
func _process(delta):
	while self.counter < self.iterazioni:
		for c in self.celle:
			var pref = seleziona_preFab(c)
			if pref.size() > 0: 
				var rand = pref.pick_random()
				c.set_prefab(rand)
		self.counter += 1


func seleziona_preFab(cella : Cella):
	var compatibilita = cella.compatibilita()
	var compatibili = []
	for pref in self.tipi_celle:
		var eGiusto = true
		for i in range(pref.bordi.size()):
			if compatibilita[i] != "" and pref.bordi[i] != "":
				eGiusto = eGiusto && (compara_str_by_caratteri(pref.bordi[i], compatibilita[i]))
		if eGiusto:
			compatibili.append(pref)
	return compatibili
	
#Funzioni Helpers:

func compara_str_by_caratteri(str1: String, str2: String) -> bool:
	if str1.length() != str2.length():
		return false
	
	var char_count = {}
	
	# Conta i caratteri nella prima stringa
	for char in str1:
		if char in char_count:
			char_count[char] += 1
		else:
			char_count[char] = 1
	
	# Verifica i caratteri nella seconda stringa
	for char in str2:
		if char in char_count:
			char_count[char] -= 1
			if char_count[char] < 0:
				return false
		else:
			return false
				
	# Se tutti i conteggi sono zero, le stringhe sono composte dagli stessi caratteri
	return true
