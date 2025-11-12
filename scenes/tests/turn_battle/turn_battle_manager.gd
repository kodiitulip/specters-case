class_name TurnBattleManager extends Node

var player_battler: PlayerBattler
var enemy_battler: EnemyBattler
var buttons: Array[Button] = []

@onready var action_buttons: VBoxContainer = $"CanvasLayer/Action Buttons"
@onready var rich_text_label: RichTextLabel = $CanvasLayer/PanelContainer/RichTextLabel

@export_multiline var enemy_flavor_text: Array[String]
@export_multiline var player_flavor_text: Array[String]
@export_multiline var player_heal_flavor_text: Array[String]
@export_file("*.tscn") var death_scene: String
@export_file("*.tscn") var victory_scene: String

func _ready() -> void:
	_set_flavor_text(["Uma batalha começa"])
	
	player_battler = get_tree().get_first_node_in_group("player_battler")
	player_battler.turn_ended.connect(_end_player_turn)
	player_battler.dead.connect(_player_dead)
	
	enemy_battler = (get_tree().get_first_node_in_group("enemy_battler"))
	enemy_battler.turn_ended.connect(_end_enemy_turn)
	enemy_battler.dead.connect(_player_wins)
	
	buttons.assign(action_buttons.get_children())
	
	for button: Button in buttons:
		if button.name.contains("Bandages"):
			button.pressed.connect(_player_heal)
			continue
		button.pressed.connect(_player_attack)


func _start_player_turn() -> void:
	for button: Button in buttons:
		button.disabled = false


func _end_player_turn() -> void:
	_start_enemy_turn()


func _player_attack() -> void:
	_set_flavor_text(player_flavor_text)
	for button: Button in buttons:
		button.disabled = true
	player_battler.attack(enemy_battler)


func _player_heal() -> void:
	await _set_flavor_text(player_heal_flavor_text)
	player_battler.heal_self()


func _start_enemy_turn() -> void:
	await enemy_battler.attack(player_battler)
	_end_enemy_turn()


func _end_enemy_turn() -> void:
	_start_player_turn()
	_set_flavor_text(enemy_flavor_text)


func _set_flavor_text(text: Array[String]) -> void:
	var t: Tween = get_tree().create_tween()
	rich_text_label.visible_ratio = 0.0
	rich_text_label.text = text.pick_random()
	t.tween_property(rich_text_label, ^"visible_ratio", 1.0, 0.8)
	await t.finished


func _player_dead() -> void:
	await _set_flavor_text(["You died"])
	SceneTransitionManager.transition_to(death_scene)


func _player_wins() -> void:
	await _set_flavor_text(["Parece que [wave]Revenant[/wave] encontrou descanso"])
	SceneTransitionManager.transition_to(victory_scene)
