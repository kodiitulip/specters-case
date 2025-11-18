class_name TurnBattleManager extends Node

@export_multiline var win_flavor_text: Array[String]
@export_multiline var die_flavor_text: Array[String]
@export_file("*.tscn") var death_scene: String
@export_file("*.tscn") var victory_scene: String

var player_battler: PlayerBattler
var enemy_battler: EnemyBattler
var buttons: Array[BattleActionButton] = []
var finished: bool = false

@onready var action_buttons: VBoxContainer = %ActionButtons
@onready var flavor_text_label: RichTextLabel = %FlavorTextLabel

func _ready() -> void:
	_set_flavor_text(["Uma batalha começa"])
	
	player_battler = get_tree().get_first_node_in_group("player_battler")
	player_battler.turn_ended.connect(_on_player_turn_ended)
	player_battler.dead.connect(_on_player_dead)
	
	enemy_battler = (get_tree().get_first_node_in_group("enemy_battler"))
	enemy_battler.turn_ended.connect(_on_enemy_turn_ended)
	enemy_battler.dead.connect(_player_wins)
	
	buttons.assign(action_buttons.get_children())
	
	for button: BattleActionButton in buttons:
		button.action_pressed.connect(_on_any_action_pressed)


func _on_any_action_pressed(action: BattleAction) -> void:
	for button: BattleActionButton in buttons:
		button.disabled = true
	_actor_action(player_battler, action)


func _actor_action(actor: Battler, action: BattleAction) -> void:
	assert(action, "Action cant be null")
	if action.attack_action_enable:
		await _actor_attack(actor, action)
	if action.heal_action_enable:
		await _actor_heal(actor, action)
	actor.end_turn()


func _actor_attack(actor: Battler, action: BattleAction) -> void:
	await _set_flavor_text(action.attack_action_flavor_text)
	match [actor, action.attack_action_target]:
		[player_battler, BattleAction.OTHER]:
			enemy_battler.be_damaged(action.attack_action_damage)
		[player_battler, BattleAction.SELF]:
			player_battler.be_damaged(action.attack_action_damage)
		[enemy_battler, BattleAction.SELF]:
			enemy_battler.be_damaged(action.attack_action_damage)
		[enemy_battler, BattleAction.OTHER]:
			player_battler.be_damaged(action.attack_action_damage)


func _actor_heal(actor: Battler, action: BattleAction) -> void:
	await _set_flavor_text(action.heal_action_flavor_text)
	match [actor, action.heal_action_target]:
		[player_battler, BattleAction.OTHER]:
			enemy_battler.heal_self(action.heal_action_amount)
		[player_battler, BattleAction.SELF]:
			player_battler.heal_self(action.heal_action_amount)
		[enemy_battler, BattleAction.SELF]:
			enemy_battler.heal_self(action.heal_action_amount)
		[enemy_battler, BattleAction.OTHER]:
			player_battler.heal_self(action.heal_action_amount)


func _on_player_turn_ended() -> void:
	if finished:
		return
	var action: BattleAction = enemy_battler.actions.pick_random()
	assert(action != null, "No enemy action found")
	_actor_action(enemy_battler, action)


func _on_enemy_turn_ended() -> void:
	if finished:
		return
	for button: BattleActionButton in buttons:
		button.reevaluate()


func _set_flavor_text(text: Array[String]) -> void:
	flavor_text_label.clear()
	var t: Tween = get_tree().create_tween()
	var flavor: String = text.pick_random()
	flavor_text_label.append_text(flavor)
	t.tween_property(flavor_text_label, ^"visible_ratio", 1.0,
		0.01 * flavor.length()).from(0.0)
	await t.finished
	await get_tree().create_timer(0.6).timeout


func _on_player_dead() -> void:
	finished = true
	await _set_flavor_text(["You died"])
	await get_tree().create_timer(1.2).timeout
	SceneTransitionManager.transition_to(death_scene)


func _player_wins() -> void:
	finished = true
	await _set_flavor_text(["Parece que [wave]Revenant[/wave] encontrou descanso"])
	await get_tree().create_timer(1.2).timeout
	SceneTransitionManager.transition_to(victory_scene)
