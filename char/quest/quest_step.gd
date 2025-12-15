class_name QuestStep extends Resource

enum StepType {TALK, COLLECT, KILL, INTERACT}

## Unique identifier for the quest step; unique across all quests.
@export var title: String
## One of a limited list of types to streamline progress code.
@export var step_type: StepType
## Text to be displayed by the journal menu to keep player informed on quest progress.
@export var description: String
## The name of the target.
@export var target_name: String
## Line of dialogue for the NPC to state if Player returns while this is the active step.
@export var line: Line
