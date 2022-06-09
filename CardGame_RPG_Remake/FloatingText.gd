extends Position2D


# https://www.youtube.com/watch?v=UlvBqz8bhCo

onready var label = $Label
onready var tween = $Tween

var amount = 0
var type = ""

var velocity = Vector2(0, 0)
var max_size = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	label.set_text(str(amount))
	
	match type:
		"phsyical":
			label.self_modulate = Color(0, 1, 0)
			pass
		"magical":
			pass
	
	randomize()
	var side_movement = randi() % 121 - 60
	
	velocity = Vector2(side_movement, 50)
	
	tween.interpolate_property(self, 'scale', scale, max_size, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', max_size, Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	
	tween.start()

func _process(delta):
	position -= velocity * delta;


func _on_Tween_tween_all_completed():
	self.queue_free()
