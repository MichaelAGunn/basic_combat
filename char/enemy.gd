class_name Enemy extends CharacterBody3D
## This is the type of character that the PC has to fight and kill.

## This signal reports Enemy deaths to the QuestManager.
signal dead(given_name: String)

var health: int = 3
var hurt_sound = preload("res://assets/sfx/hurt.wav")
var die_sound = preload("res://assets/sfx/death.wav")

## The name of the character according to the story; to be displayed by the UI and HUD.
@export var given_name: String

@onready var body = $Body
@onready var space = $Space
@onready var anima = $AnimationPlayer
@onready var enemy_voice = $EnemyVoice
@onready var death_timer = $DeathTimer

func _ready() -> void:
	Global.player.strike.connect(_on_player_strikes)
	anima.play('idle')

## Removes the enemy when its health reaches 0.
func die() -> void:
	await enemy_voice.finished
	emit_signal('dead', given_name)
	death_timer.start()
	await death_timer.timeout
	queue_free()

## Applies damage to the Enemy when the Player attacks and hits it.
func _on_player_strikes(got_stricken: PhysicsBody3D) -> void:
	if self == got_stricken:
		health -= 1
		if health > 0:
			anima.play('hurt')
			enemy_voice.set_stream(hurt_sound)
			enemy_voice.play()
		else:
			anima.play('die')
			enemy_voice.set_stream(die_sound)
			enemy_voice.play()
			die()

## Defaults player animation to idle before Enemy changes state.
func _on_animation_player_animation_finished(_anim_name):
	anima.play('idle')
