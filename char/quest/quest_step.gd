class_name QuestStep extends Resource

enum StepType {TALK, COLLECT, KILL}

## Unique identifier for the quest step; unique across all quests.
@export var title: String
## One of a limited list of types to streamline progress code.
@export var step_type: StepType
## Text to be displayed by the journal menu to keep player informed on quest progress.
@export var description: String
## The name of the target.
@export var target_name: String
## The number of targets to reach before the next step.
@export var number: int = 1
## Is this step active?
@export var active: bool = false
