class_name NPC extends CharacterBody3D

signal speak(given_name: String, message: String, audio_file: String)
signal player_enters_radius
signal player_exits_radius

enum Lines {GREETING, ASK, INSIST, THANK, DONE}
var line: int

@export var given_name: String
@export var dialogue: Dialogue
@export var quest: Quest

@onready var body = $Body
@onready var space = $Space
@onready var speak_radius = $SpeakRadius

func _ready() -> void:
	Global.player.interact.connect(_on_player_interacts)
	QuestManager.quest_completed.connect(_on_quest_completed)
	if quest in QuestManager.complete_quests:
		line = Lines.THANK
	else:
		line = Lines.GREETING

func _on_player_interacts() -> void:
	if Global.player in speak_radius.get_overlapping_bodies():
		match line:
			Lines.GREETING:
				emit_signal('speak', self, given_name, dialogue.greeting.message, dialogue.greeting.audio)
				if quest != null:
					line = Lines.ASK
			Lines.ASK:
				emit_signal('speak', self, given_name, dialogue.ask.message, dialogue.ask.audio)
				QuestManager.activate_quest(quest)
				line = Lines.INSIST
			Lines.INSIST:
				# TODO Change the dialogue to whatever's in the quest step!!!!!!!!!!!!!!!!!
				var quest_step = QuestManager.find_quest_by_title(quest.title).steps_active[0]
				emit_signal('speak', self, given_name, quest_step.line.message, quest_step.line.audio)
			Lines.THANK:
				emit_signal('speak', self, given_name, dialogue.thank.message, dialogue.thank.audio)
				line = Lines.DONE
			Lines.DONE:
				emit_signal('speak', self, given_name, dialogue.done.message, dialogue.done.audio)

func _on_quest_completed(completed_quest: Quest) -> void:
	if completed_quest == quest:
		line = Lines.THANK

func _on_speak_radius_body_entered(entered_body):
	if entered_body == Global.player:
		emit_signal('player_enters_radius')

func _on_speak_radius_body_exited(exited_body):
	if exited_body == Global.player:
		emit_signal('player_exits_radius')
