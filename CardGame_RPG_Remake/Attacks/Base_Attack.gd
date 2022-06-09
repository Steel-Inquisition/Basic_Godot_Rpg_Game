extends Node2D
class_name attack, "res://Images/knife.png"

export var attack_name = "Stab"
export var damage_type = "phys"
export var damage = 2
export var random_damage = 7
export var accuracy = 1
export var hits = 1
export var mana_type = ["phys", 1]

export var description = "A basic stab."

# Called when the node enters the scene tree for the first time.
func _ready():
	#attack_name + " (" + damage_type + ")" +  ": " + description + " Hits " + str(hits) + " time(s)!"
	pass # Replace with function body.

func deal_damage():
	return damage + (randi() % random_damage)

func special_function():
	print("None")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
