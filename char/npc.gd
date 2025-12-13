class_name NPC extends CharacterBody3D

@onready var body = $Body
@onready var space = $Space
@onready var talk_radius = $TalkRadius

func _ready() -> void:
	Global.player.interact.connect(_on_player_interacts)

func _on_player_interacts() -> void:
	if Global.player in talk_radius.get_overlapping_bodies():
		print("Hello world!")
