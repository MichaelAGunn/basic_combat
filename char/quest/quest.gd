class_name Quest extends Resource

enum Progress {UNKNOWN, ACTIVE, COMPLETE}

## The given name of the NPC who gives the quest to the PC.
@export var quest_giver: String
## The unique identifier for the quest manager.
@export var title: String
## The list of steps that have not been done; begins with all of the steps.
@export var steps_to_do: Array[QuestStep] = []
## The list of steps that currently need to be done.
var steps_active: Array[QuestStep] = []
## The list of steps that have been done; quest is completed when all mandatory steps are here.
var steps_complete: Array[QuestStep] = []
## What the player gets at the end of the quest.
@export var reward: String
## Progress level of the quest, for journal sorting.
@export var progress: Progress = Progress.UNKNOWN

#var step_count: int = 0
#var current_step: QuestStep = steps[step_count]

#func next_step() -> void:
	#step_count += 1
	#current_step = steps[step_count]
