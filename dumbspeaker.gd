extends Node3D

signal started

enum EMOTE {
	HAPPY,
	SAD,
	ANGRY,
	SCHEMING,
	NEUTRAL
}

var emotion = EMOTE.NEUTRAL
var mouth1 = preload("res://textures/mouth/happy.tres")
var mouth2 = preload("res://textures/mouth/sad.tres")
var mouth3 = preload("res://textures/mouth/neutral.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("idle")
	await started
	$AnimationPlayer.play("talk")
	await $voice.say("hello, this is me talking, i hope you all have a wonderful christmas.", "cmu_us_slt")
	await $voice.say("i am at the Club house of awesomeness, which is at floor 1 hundred eighty one of the Yoyle Needy", "cmu_us_slt")
	$AnimationPlayer.play("slap")
	await $voice.say("Don't call me needy!", "cmu_us_slt")
	$AnimationPlayer.play("dropdead")
	await $voice.say("since i am very dumb i am gonna listen to this music for the rest of my life.", "cmu_us_slt")
	$AnimationPlayer.play("rage")
	await $voice.say("okay, time to dance! i am sooooo excited", "cmu_us_slt")
	$AnimationPlayer.play("angery")
	await $voice.say("i do not know why i am so angry", "cmu_us_slt")
	$AnimationPlayer.play("dance")
	
	var response = [
		"man, i am having such a fun time dancing",
		"woah, this dancing is getting tiring.",
		"this is awesome",
		"i love dancing",
		"man, i sure do love dancing!",
		"dancing is my specialty",
		"i am lost in the groove",
		"i am grounded grounded grounded grounded for dancing too good"
	]
	
	var time = Timer.new()
	time.wait_time = 12
	time.autostart = true
	add_child(time)
	time.timeout.connect(func():
		$AnimationPlayer.play("idle")
		await $voice.say(response.pick_random(), "cmu_us_slt")
		$AnimationPlayer.play("dance")
	)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		emit_signal("started")
	
	# Lip syncing
	var idx = AudioServer.get_bus_index("voice")
	var loud = AudioServer.get_bus_peak_volume_left_db(idx, 0) + 40
	loud = clamp(loud*1.35, 0, 60)
	
	$torso/neck/mouth.frame = floor(loud / 10)
	
	match emotion:
		EMOTE.HAPPY, EMOTE.SCHEMING:
			$torso/neck/mouth.sprite_frames = mouth1
		EMOTE.SAD, EMOTE.ANGRY:
			$torso/neck/mouth.sprite_frames = mouth2
		EMOTE.NEUTRAL:
			$torso/neck/mouth.sprite_frames = mouth3
