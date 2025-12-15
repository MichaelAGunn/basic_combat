class_name HUD extends Control

var current_speaker: NPC

@onready var dialogue = $Dynamic/Dialogue
@onready var quest_step = $Dynamic/QuestStep
@onready var quest_cooldown = $Dynamic/QuestStep/QuestCooldown
@onready var voice = $VoicePlayer
@onready var cooldown = $VoicePlayer/Cooldown
@onready var key_prompt_margin = $KeyPromptMargin
@onready var key_sprite = $KeyPromptMargin/KeyPrompt/KeySprite
@onready var key_label = $KeyPromptMargin/KeyPrompt/KeyLabel

func _ready() -> void:
	Global.hud = self
	QuestManager.quest_updated.connect(_on_quest_updated)
	for npc in get_tree().get_nodes_in_group('npcs'):
		npc.speak.connect(_on_npc_speaks)
		npc.player_enters_radius.connect(_on_player_enters_npc)
		npc.player_exits_radius.connect(_on_player_leaves_npc)
	for interactable in get_tree().get_nodes_in_group('interactables'):
		interactable.player_enters_radius.connect(_on_player_enters_inter)
		interactable.player_exits_radius.connect(_on_player_exits_inter)

func _on_npc_speaks(npc: NPC, npc_name: String, message: String, audio_file: String) -> void:
	#if current_speaker != npc:
	current_speaker = npc
	var audio = load(audio_file)
	voice.set_stream(audio)
	voice.play()
	dialogue.show()
	dialogue.text = npc_name + ': ' + message

func _on_voice_player_finished() -> void:
	current_speaker = null
	cooldown.start()

func _on_cooldown_timeout() -> void:
	dialogue.hide()

func _on_player_enters_npc() -> void:
	key_label.text = "Talk"
	key_prompt_margin.show()

func _on_player_leaves_npc() -> void:
	key_prompt_margin.hide()
	if voice.is_playing():
		current_speaker = null
		voice.stop()
		dialogue.hide()

func _on_player_enters_inter() -> void:
	key_label.text = "Interact"
	key_prompt_margin.show()

func _on_player_exits_inter() -> void:
	key_prompt_margin.hide()

func _on_quest_updated(step: QuestStep) -> void:
	quest_step.text = step.description
	quest_step.show()
	quest_cooldown.start()
	await quest_cooldown.timeout
	quest_step.hide()
