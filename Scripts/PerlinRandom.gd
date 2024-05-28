extends Node
class_name PerlinRandom

@export var randomSeed = randi() % 3000

func randi():
	var valore = sin(2+randomSeed)+sin(PI*randomSeed)
	valore *= sqrt(sqrt(abs(randomSeed)))
	self.randomSeed +=1
	return int(valore)

func randf():
	var valore = sin(2+randomSeed)+sin(PI*randomSeed)
	valore *= sqrt(sqrt(abs(randomSeed)))
	self.randomSeed +=1
	return float(valore)

func randi_range(b = 0, t = b+1):
	var valore = self.randi()
	if t == 0:
		return 0
	valore = (valore % t)+b
	return int(valore)

func randf_range(b = 0, t = b+1):
	var valore = self.randf()
	if t == 0:
		return 0
	valore = (valore % t)+b
	return valore
