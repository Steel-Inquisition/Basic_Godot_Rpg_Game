extends Node2D


onready var PlayerNodes = $Players
onready var EnemyNodes = $Enemies
onready var UiNodes = $UI
onready var EnemyWait : Timer = $EnemyWait

var AllPlayers : Array
var AllEnemies : Array

var CurrentPlayer = 0
var CurrentEnemy = 0
onready var ActionMenu : MenuButton = $UI/MenuButtons

var current_attacks
var current_attack

var can_attack = false

var press_turns = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Connect the action button to this script
	ActionMenu.get_popup().connect("id_pressed",self,"ready_attack")
	
	# Get all the players and all the enemies
	AllPlayers = $Players.get_children()
	AllEnemies = $Enemies.get_children()
	
	# Connect the mouse actions to the enemies
	for i in AllEnemies.size():
		AllEnemies[i].connect("test_mouse_input",self,"attack_this")
	
	# Get the amount of press turns based on the current amount of players
	press_turns = AllPlayers.size()

	# Ready the Players
	_ready_player(CurrentPlayer)
	
	# Show how much press turns are active
	_change_ui()

func _ready_player(this_player):
	
	# If the total party is alive
	if (AllPlayers.size() > 0):
		
		# Set current chosen player to be shown as active (green)
		AllPlayers[this_player]._active()
		
		# Clear out the action menu
		ActionMenu.get_popup().clear()
		
		# Get the current attacks of this player
		current_attacks = AllPlayers[this_player].get_node("Attacks").get_children()
		
		# Set up the current attcks to the action menu
		_set_up_player(current_attacks)

func _set_up_player(this_player):
	ActionMenu.add_these_times(this_player)

func _change_ui():
	$UI/PressTurnSymbol.change_this(press_turns)

# Based on Menu, Select this Attack
# it sends an ID that can be used to select the attack from the current_attacks allowed
func ready_attack(ID):
	
	# Select current attack based on what was selected in the menu
	current_attack = current_attacks[ID]
	
	# Change visibility so you know what you can attack
	change_visibility()
	
	# Allow the ability to attack
	can_attack = true

# Based on Click, Deal damage to it
func attack_this(this):
	
	# If the player is allowed to attack
	if (can_attack):
		
		# The unit that was selected is taken damage
		this.attempt_attack(current_attack.deal_damage(), AllPlayers[CurrentPlayer].accuracy + current_attack.accuracy, current_attack.hits, current_attack.damage_type)
		
		# Change visibility so you know that the attack works
		change_visibility()
		
		# Go to the next turn
		next_turn()
		
		# The player can no longer click to attack
		can_attack = false

func next_turn():
	
	# if there are more than 1 press turn
	if (press_turns > 1):
		
		# Subtract the current press turn by 1
		press_turns -= 1
		
		# Show the current amount of press turns
		_change_ui()
		
		# Show that this player is no longer attacking by turning it's border black again
		AllPlayers[CurrentPlayer]._deactive()
		
		#  Move to the next player
		CurrentPlayer += 1
		
		# Ready this player again
		_ready_player(CurrentPlayer)
	else:
		
		# Move onto the enemy turn
		
		# Deactive the last player
		AllPlayers[CurrentPlayer]._deactive()
		
		# Get the current enemies alive now
		AllEnemies = $Enemies.get_children()
		
		# Get the number of press turns the enemies can use
		press_turns = AllEnemies.size()
		
		# I don't know why I have to do this fix, wth
		#if (press_turns == 2):
			#press_turns = 1
		
		# Show how many press turns the enemies have visually
		_change_ui()
		
		# Show that the player can no longer attack
		change_button_visibility()
		
		# enemy can attack now
		if (AllEnemies.size() > 0):
			enemy_starts_attack()


func enemy_starts_attack():
	
	# Get the current number of players
	AllPlayers = $Players.get_children()
	
	# Start the timer for when the enemy can attack
	EnemyWait.start()
	EnemyWait.one_shot = true

func _on_EnemyWait_timeout():
	
	# if there are more than 0 press turns
	if (press_turns > 0):
		
		# Get all the players that are currently alive
		AllPlayers = $Players.get_children()
		
		print("This enemy attacks!")

		# Get the attacks from the enemy
		if (is_instance_valid(AllEnemies[CurrentEnemy]) && AllPlayers.size() > 0):
			
			print("...and the attack is actually valid!")
			
			current_attacks = AllEnemies[CurrentEnemy].get_node("Attacks").get_children()
		
			# Target Random Player
			var random_player = randi() % AllPlayers.size()
		
			# Get Random Attack
			var random_attack = randi() % current_attacks.size()
		
			# Get Current Attack based on Random Attack Number
			current_attack = current_attacks[random_attack]
		
			# Deal Damage
			AllPlayers[random_player].attempt_attack(current_attack.deal_damage(), AllEnemies[CurrentEnemy].accuracy + current_attack.accuracy, current_attack.hits, current_attack.damage_type)
		
		# subtract the current number of press turns
		press_turns -= 1
		
		# move to the next enemy to attack
		CurrentEnemy += 1
		
		# show how many press turns are left
		_change_ui()
		
		# restart the timer so the next enemy can attack
		enemy_starts_attack()
	else:
		
		# Move onto the player turns
		
		# Get the current amount of enemy and players left
		AllPlayers = $Players.get_children()
		AllEnemies = $Enemies.get_children()
		
		# Get the current number of press turns by how many players are left
		press_turns = AllPlayers.size()
		
		# Show the amount of press turns the player has
		_change_ui()
		
		# Show that you can attack using the menu again
		change_button_visibility()
		
		# Set the current player and enemy back to 0, the starting ones
		CurrentPlayer = 0
		CurrentEnemy = 0
		
		# Read this player
		_ready_player(CurrentPlayer)


# Players and UI visibility
func change_visibility():
	PlayerNodes.visible = !PlayerNodes.visible
	UiNodes.visible = !UiNodes.visible

# Just the attack menu visibility
func change_button_visibility():
	$UI/MenuButtons.visible = !$UI/MenuButtons.visible
