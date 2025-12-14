class_name Quest extends Resource

enum Progress {UNKNOWN, ACTIVE, COMPLETE}

## The given name of the NPC who gives the quest to the PC.
@export var quest_giver: String
## The unique identifier for the quest manager.
@export var quest_name: String
## The list of steps required to complete the quest.
@export var steps: Array[QuestStep]
## What the player gets at the end of the quest.
@export var reward: String
## Progress level of the quest, for journal sorting.
@export var progress: Progress = Progress.UNKNOWN

#var step_count: int = 0
#var current_step: QuestStep = steps[step_count]

#func next_step() -> void:
	#step_count += 1
	#current_step = steps[step_count]
