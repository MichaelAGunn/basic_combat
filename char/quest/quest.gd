class_name Quest extends Resource

## The given name of the NPC who gives the quest to the PC.
@export var quest_giver: String
## The unique identifier for the quest manager.
@export var quest_name: String
## The list of steps required to complete the quest.
@export var steps: Array[QuestStep]
## What the player gets at the end of the quest.
@export var reward: String
