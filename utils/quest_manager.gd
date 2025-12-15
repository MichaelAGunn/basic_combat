extends Node

## Informs the UI about quest updates, and briefly displays the new quest log on the HUD.
signal quest_updated(step: QuestStep)
## Informs the quest-giving NPC to change his dialogue to something thankful.
signal quest_completed(quest: Quest)

const QUEST_RESOURCE_PATH: String = "res://char/quest/resources/"

var quests: Array[Quest]
var active_quests: Array[Quest] = []
var complete_quests: Array[Quest] = []
var dead_enemies: Array[String]

func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group('enemies'):
		enemy.dead.connect(_on_enemy_dies)
	for interactable in get_tree().get_nodes_in_group('interactables'):
		interactable.interaction.connect(_on_interaction)
	gather_quest_data()

## Populate quest array with all quest resources.
func gather_quest_data() -> void:
	quests.clear()
	var quest_files: PackedStringArray = DirAccess.get_files_at(QUEST_RESOURCE_PATH)
	for q in quest_files:
		quests.append(load(QUEST_RESOURCE_PATH + q) as Quest)

## Add quest to active quest array and allow it to be displayed by the UI and HUD.
func activate_quest(quest: Quest) -> void:
	active_quests.append(quest)
	var first_step: QuestStep = quest.steps_to_do[0]
	quest.steps_active.append(first_step)
	quest.steps_to_do.erase(first_step)
	emit_signal('quest_updated', first_step)
	if first_step.step_type == QuestStep.StepType.KILL:
		if first_step.target_name in dead_enemies:
			update_quest(quest)

## Moves the active step into the completed steps list, and the next step into the active step list.
## Currently only handles linear quests with one active step at a time.
func update_quest(quest: Quest) -> void:
	var active_step: QuestStep = quest.steps_active[0]
	var next_step: QuestStep = quest.steps_to_do[0] if len(quest.steps_to_do) > 0 else null
	quest.steps_complete.append(active_step)
	quest.steps_active.erase(active_step)
	if next_step != null:
		quest.steps_active.append(next_step)
		quest.steps_to_do.erase(next_step)
		emit_signal('quest_updated', next_step)
		if next_step.step_type == QuestStep.StepType.KILL:
			if next_step.target_name in dead_enemies:
				update_quest(quest)
	else:
		quest.steps_to_do.erase(next_step)
		complete_quest(quest)

## Remove quest from active quest array and give rewards to player.
func complete_quest(quest: Quest) -> void:
	complete_quests.append(quest)
	active_quests.erase(quest)
	emit_signal('quest_completed', quest)

## Returns a quest based on title argument.
func find_quest_by_title(title: String) -> Quest:
	for q in quests:
		if q.title == title:
			return q
	return null

## Returns index in the quest array for a quest based on title argument.
func find_quest_index_by_title(title: String) -> int:
	for i in range(active_quests.size()):
		if active_quests[i].title == title:
			return i
	return -1

func _on_enemy_dies(enemy_name: String) -> void:
	dead_enemies.append(enemy_name)
	for q in active_quests:
		for s in q.steps_active:
			if s.step_type == QuestStep.StepType.KILL:
				if s.target_name == enemy_name:
					update_quest(q)

func _on_interaction(object_name: String) -> void:
	for q in active_quests:
		for s in q.steps_active:
			if s.step_type == QuestStep.StepType.INTERACT:
				if s.target_name == object_name:
					update_quest(q)
