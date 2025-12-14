class_name NPC extends CharacterBody3D

signal speak(message: String, audio_file: String)
signal player_leaves_early

enum Lines {GREETING, ASK, INSIST, THANK}
var line: int

@export var given_name: String
@export var dialogue: Dialogue
@export var quest: Quest

@onready var body = $Body
@onready var space = $Space
@onready var speak_radius = $SpeakRadius

func _ready() -> void:
	Global.player.interact.connect(_on_player_interacts)
	line = Lines.GREETING

func _on_player_interacts() -> void:
	if Global.player in speak_radius.get_overlapping_bodies():
		match line:
			Lines.GREETING:
				emit_signal('speak', self, dialogue.greeting.message, dialogue.greeting.audio)
				line = Lines.ASK
			Lines.ASK:
				emit_signal('speak', self, dialogue.ask.message, dialogue.ask.audio)
				line = Lines.INSIST
			Lines.INSIST:
				emit_signal('speak', self, dialogue.insist.message, dialogue.insist.audio)
			Lines.THANK:
				emit_signal('speak', self, dialogue.thank.message, dialogue.thank.audio)

func _on_speak_radius_body_exited(body):
	if body == Global.player:
		emit_signal('player_leaves_early')
