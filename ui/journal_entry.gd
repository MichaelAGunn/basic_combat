class_name JournalEntry extends VBoxContainer
## A UI container for quest data.
## Used for displaying both active and completed quests.

@export var quest: Quest

@onready var title = $Title

#func _ready() -> void:
func add_text() -> void:
	title.text = quest.title
	#for step in quest.steps_complete:
		#var step_label = Label.new()
		#add_child(step_label)
		#step_label.text = step.title
	#for step in quest.steps_active:
		#var step_label = Label.new()
		#step_label.text = step.title
		#add_child(step_label)
