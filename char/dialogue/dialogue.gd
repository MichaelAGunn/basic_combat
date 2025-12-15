class_name Dialogue extends Resource

## Line for first contact with NPC.
@export var greeting: Line
## Line for NPC to activate his quest (if he has one).
@export var ask: Line
## Line for NPC to say after his quest is completed (if he has one).
@export var thank: Line
## Line for NPC to permanently say after he has thanked the NPC for completing his quest.
@export var done: Line
