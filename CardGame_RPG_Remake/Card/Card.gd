extends Area2D
class_name card

enum types {
	ALLY, ENEMY
}

export (types) var this_type = types.ALLY

onready var health_bar = $Bars/HealthBar
onready var Hp : Label = $Bars/Hp

onready var mp_bar = $Bars/MpBar
onready var Mp : Label = $Bars/Mp

onready var FloatingText = preload("res://FloatingText/FloatingText.tscn")

export var card_name = ""
export var card_type = ""

export var health = 20
export var magic = 5
export var endurance = 3
export var agility = 10
export var accuracy = 10

export var inventory = 1

signal test_mouse_input

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = health
	health_bar.value = health
	
	Hp.text = str(health)
	
	mp_bar.max_value = magic
	mp_bar.value = magic
	
	Mp.text = str(magic)
	
	if (this_type == types.ENEMY):
		$PlayerView.visible = false
	

func _active():
	$PlayerView/Background.self_modulate = Color(0, 1, 0)

func _deactive():
	$PlayerView/Background.self_modulate = Color(0, 0, 0, 1)

func attempt_attack(damage, enemy_accuracy, number_of_attacks, damage_type):
	
	var num_successful_attacks = 0
	
	for i in number_of_attacks:
		randomize()
		
		var adjusted_enemy_accuracy = (randi() % 100) + enemy_accuracy
		var adjusted_agility = (randi() % 100) + agility
		
		if (adjusted_enemy_accuracy >= adjusted_agility):
			num_successful_attacks += 1
		else:
			miss_reaction()
	
	for i in num_successful_attacks:
		take_damage(damage, damage_type)



func take_damage(damage, damage_type):
	
	var total_damage = damage - endurance
	
	health -= total_damage
	health_bar.value = health
	Hp.text = str(health)
	damage_reaction(total_damage)
	check_if_dead()

func damage_reaction(damage):
	var text = FloatingText.instance()
	
	if (damage > 5):
		text.scale *= 2
		text.self_modulate = Color(1, 0, 0)
	
	text.amount = str(damage)
	add_child(text)

func miss_reaction():
	var text = FloatingText.instance()
	text.amount = "miss"
	add_child(text)


func check_if_dead():
	if (health <= 0):
		$DeathTimer.start()

func _on_Card_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		emit_signal("test_mouse_input", self)


func _on_DeathTimer_timeout():
	queue_free()
