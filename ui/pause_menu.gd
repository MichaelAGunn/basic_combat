class_name PauseMenu extends Control

signal game_paused
signal game_unpaused

const JOURNAL_ENTRY = preload("res://ui/journal_entry.tscn")

@onready var main_menu = $ColorRect/MainMenu
@onready var resume = $ColorRect/MainMenu/Resume
@onready var journal = $ColorRect/MainMenu/Journal
@onready var quit = $ColorRect/MainMenu/Quit
@onready var journal_menu = $ColorRect/JournalMenu
#@onready var active_quests = $ColorRect/JournalMenu/HBoxContainer/ActiveQuests
#@onready var complete_quests = $ColorRect/JournalMenu/HBoxContainer/CompleteQuests
#@onready var active_desc = $ColorRect/JournalMenu/HBoxContainer/Description/ActiveDesc
@onready var active_button = $ColorRect/JournalMenu/QuestTabs/ActiveButton
@onready var complete_button = $ColorRect/JournalMenu/QuestTabs/CompleteButton
@onready var journal_entries = $ColorRect/JournalMenu/QuestScroll/JournalEntries
@onready var journal_back = $ColorRect/JournalMenu/JournalBack

func _ready() -> void:
	Global.pause_menu = self
	self.hide()

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if self.visible:
			self.hide()
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			emit_signal('game_unpaused')
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
			self.show()
			emit_signal('game_paused')

func display_quests(quests: Array[Quest]) -> void:
	for child in journal_entries.get_children():
		journal_entries.remove_child(child)
		child.queue_free()
	for q in quests:
		var je = JOURNAL_ENTRY.instantiate()
		journal_entries.add_child(je)
		je.quest = q
		je.add_text()

func _on_resume_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	self.hide()
	emit_signal('game_unpaused')

func _on_journal_pressed():
	main_menu.hide()
	journal_menu.show()
	display_quests(QuestManager.active_quests)
	#populate_journal()

func _on_quit_pressed():
	get_tree().quit()

func _on_journal_back_pressed():
	journal_menu.hide()
	main_menu.show()

func _on_active_button_pressed():
	display_quests(QuestManager.active_quests)

func _on_complete_button_pressed():
	display_quests(QuestManager.complete_quests)
