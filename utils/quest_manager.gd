extends Node

var active_quests: Array[Quest]

func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group('enemies'):
		enemy.dead.connect(_on_enemy_death)

func quest_activated(quest: Quest) -> void:
	active_quests.append(quest)

func quest_completed(quest: Quest) -> void:
	active_quests.erase(quest)

func _on_enemy_death(enemy_name: String) -> void:
	for quest in active_quests:
		if quest.type == 'Kill':
			print("Kill quest.")
			if quest.target == enemy_name:
				print("Target destroyed!")
