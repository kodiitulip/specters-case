class_name BattleAction
extends Resource

const SELF: TargetType = TargetType.SELF
const OTHER: TargetType = TargetType.OTHER

enum TargetType {
	SELF,
	OTHER,
}

@export_group("Item Requirements", "")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var item_requirements_enable: bool = false
@export var required_item: ItemData

@export_group("Attack Action", "attack_action_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var attack_action_enable: bool = false
@export var attack_action_damage: int = 1
@export var attack_action_target: TargetType = TargetType.OTHER
@export_multiline var attack_action_flavor_text: Array[String] = []

@export_group("Heal Action", "heal_action_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var heal_action_enable: bool = false
@export var heal_action_amount: int = 1
@export var heal_action_target: TargetType = TargetType.SELF
@export_multiline var heal_action_flavor_text: Array[String] = []
