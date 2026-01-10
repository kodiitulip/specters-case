class_name TurnBattleManager extends Node

signal interacted()
signal enemy_chosen()

@export_group("Flovor Text", "flavor_text_")
@export_multiline var flavor_text_on_win: Array[String]
@export_multiline var flavor_text_on_death: Array[String]

@export_group("Scene Files", "scene_")
@export_file("*.tscn") var scene_on_death: String
@export_file("*.tscn") var scene_on_victory: String
@export_file("*.tscn") var scene_on_fleeing: String

var player_battler: Battler
var enemy_battlers: Array[EnemyBattler]
var chosen_enemy: EnemyBattler
var buttons: Array[Button] = []
var finished: bool = false

@export_group("UI", "ui_")
@export var ui_action_buttons: GridContainer
@export var ui_enemy_choose_buttons: VBoxContainer
@export var ui_flavor_text_label: RichTextLabel
@export var ui_flee_button: Button
@export var ui_interact_indicator: TextureRect

func _ready() -> void:
	_set_flavor_text(["Uma batalha começa. O que você faz?"])
	
	player_battler = get_tree().get_first_node_in_group("player_battler")
	player_battler.turn_ended.connect(_on_player_turn_ended)
	player_battler.dead.connect(_on_player_dead)
	
	enemy_battlers.assign(get_tree().get_nodes_in_group("enemy_battler").filter(
		func(c: Node) -> bool:
			return c is EnemyBattler))
	for enemy: EnemyBattler in enemy_battlers:
		enemy.turn_ended.connect(_on_enemy_turn_ended)
		enemy.dead.connect(_player_wins)
		var enemy_button: Button = Button.new()
		enemy_button.set_text(enemy.stats.resource_name)
		enemy_button.pressed.connect(_choose_enemy.bind(enemy))
		assert(ui_enemy_choose_buttons != null)
		ui_enemy_choose_buttons.add_child(enemy_button)
	
	assert(ui_action_buttons != null, "No [code]ui_action_buttons[/code] selected")
	buttons.assign(ui_action_buttons.get_children().filter(func(c: Node) -> bool:
		return c is Button))
	ui_action_buttons.visibility_changed.connect(
		_grab_focus_on_first_button.bind(ui_action_buttons))
	ui_enemy_choose_buttons.visibility_changed.connect(
		_grab_focus_on_first_button.bind(ui_enemy_choose_buttons))
	
	for button: Button in buttons:
		if button is BattleActionButton:
			(button as BattleActionButton
			).action_pressed.connect(_on_any_action_pressed)
	
	if ui_flee_button:
		ui_flee_button.pressed.connect(func() -> void:
			SceneTransitionManager.transition_to(scene_on_fleeing))
	if ui_interact_indicator:
		ui_interact_indicator.hide()
		interacted.connect(ui_interact_indicator.hide)
	_grab_focus_on_first_button(ui_action_buttons)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(&"dialogic_default_action"):
		interacted.emit()


func _choose_enemy(enemy: EnemyBattler) -> void:
	chosen_enemy = enemy
	ui_enemy_choose_buttons.hide()
	ui_action_buttons.show()
	enemy_chosen.emit()


func _on_any_action_pressed(action: BattleAction) -> void:
	for button: Button in buttons:
		button.set_disabled(true)
	_actor_action(player_battler, action)


func _actor_action(actor: Battler, action: BattleAction) -> void:
	assert(action, "Action cant be null")
	if action.attack_action_enable:
		await _actor_attack(actor, action)
	if action.heal_action_enable:
		await _actor_heal(actor, action)
	if ui_interact_indicator:
		ui_interact_indicator.show()
	await interacted
	actor.end_turn()


func _actor_attack(actor: Battler, action: BattleAction) -> void:
	if actor == player_battler:
		ui_action_buttons.hide()
		ui_enemy_choose_buttons.show()
		await enemy_chosen
	await _set_flavor_text(action.attack_action_flavor_text)
	match [actor, action.attack_action_target]:
		[player_battler, BattleAction.OTHER]:
			chosen_enemy.be_damaged(action.attack_action_damage)
		[_, BattleAction.OTHER]:
			player_battler.be_damaged(action.attack_action_damage)
		[_, BattleAction.SELF]:
			actor.be_damaged(action.attack_action_damage)


func _actor_heal(actor: Battler, action: BattleAction) -> void:
	await _set_flavor_text(action.heal_action_flavor_text)
	match [actor, action.heal_action_target]:
		[player_battler, BattleAction.OTHER]:
			chosen_enemy.heal_self(action.heal_action_amount)
		[_, BattleAction.OTHER]:
			player_battler.heal_self(action.heal_action_amount)
		[_, BattleAction.SELF]:
			actor.heal_self(action.heal_action_amount)


func _on_player_turn_ended() -> void:
	if finished:
		return
	var action: BattleAction = chosen_enemy.actions.pick_random()
	assert(action != null, "No enemy action found")
	_actor_action(chosen_enemy, action)


func _on_enemy_turn_ended() -> void:
	if finished:
		return
	for button: Button in buttons:
		if button is BattleActionButton:
			(button as BattleActionButton).reevaluate()
		# NOTE: remove this check when items are availlable
		elif button.name != "Items":
			button.set_disabled(false)
	_set_flavor_text(["O que você faz?"])


func _set_flavor_text(text: Array[String]) -> void:
	if not ui_flavor_text_label:
		printerr("No [code]ui_flavor_text[/code] Label selected"); return
	ui_flavor_text_label.clear()
	var t: Tween = get_tree().create_tween()
	var flavor: String = text.pick_random() if not text.is_empty() else ""
	ui_flavor_text_label.append_text(flavor)
	t.tween_property(ui_flavor_text_label, ^"visible_ratio", 1.0,
		0.01 * flavor.length()).from(0.0)
	await t.finished
	await get_tree().create_timer(0.6).timeout


func _on_player_dead() -> void:
	finished = true
	await _set_flavor_text(flavor_text_on_death)
	await get_tree().create_timer(1.2).timeout
	SceneTransitionManager.transition_to(scene_on_death)


func _player_wins() -> void:
	finished = true
	await _set_flavor_text(flavor_text_on_win)
	await get_tree().create_timer(1.2).timeout
	SceneTransitionManager.transition_to(scene_on_victory)


func _grab_focus_on_first_button(container: Control) -> void:
	var bs: Array[Button] = []
	bs.assign(container.get_children().filter(func(c: Node) -> bool:
		return c is Button))
	var first: Button = bs.get(0)
	if not first:
		return
	first.grab_focus.call_deferred()
