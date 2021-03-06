extends Node

var skiped = false
var dead = false

signal next

func _world_changes():
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property($WorldEnvironment.environment, "adjustment_contrast", 
		$WorldEnvironment.environment.adjustment_contrast, 1.4, 60,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	var _err = yield(get_tree().create_timer(60), "timeout")
	tween.interpolate_property($WorldEnvironment.environment, "adjustment_contrast", 
		$WorldEnvironment.environment.adjustment_contrast, 1, 60,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _ready():
	Checkpoint.current_level = "res://scenes/Levels/Level2.tscn"
	
	$Dialog.say("Welcome to stage 2, here I will test your... determination. ", 6)
	yield(self, "next")
	$Dialog.say("You know... I like adventurers, they come from time to time to visit me ", 7)
	yield(self, "next")
	$Dialog.say("Sometimes I make a cake for my visitors... ", 5)
	yield(self, "next")
	$Dialog.say("Do you... do you want one?", 3)
	yield(self, "next")
	
	if not skiped:
		$"../MusicPlayer".play()
		$"../MusicInfo".start()
		_world_changes()
	
	$Dialog.hide_skip_button()

func _on_MusicPlayer_finished():
	if not dead:
		Checkpoint.current_level = "res://scenes/Levels/Level3.tscn"
		$Dialog.show()
		$Dialog.say("Congratulations, let's go to the next stage? the cake is already done and waiting for you!", 8)
		yield(self, "next")
		
		var _err = get_tree().change_scene("res://scenes/Levels/Level3.tscn")

func _on_Player_dead():
	if not dead:
		Checkpoint.deaths += 1
		dead = true
		$"../MusicPlayer".stop()
	
		$Dialog.show()
		$Dialog.say("Hehe", 3)
		yield(self, "next")
		
		# feature
		if Checkpoint.deaths > 5:
			$Dialog.say("*Gamedev 1: Hey, pssss, I was watching you, and I noticed that you are having a bad time...*", 10)
			yield(self, "next")
			$Dialog.say("*Gamedev 1: So here goes a hint: try to keep the right button pressed while spamming the left button of the mouse*", 14)
			yield(self, "next")
			$Dialog.say("*Gamedev 2: Hey, wait a second, that's a bug!*", 5)
			yield(self, "next")
			$Dialog.say("*Gamedev 1: Nope, I promoted it to a feature :P*", 6)
			yield(self, "next")
			$Dialog.say("*Gamedev 2: You...*", 3)
			yield(self, "next")
			Checkpoint.deaths = 0
		
		$Dialog.say("*System error: restarting...*", 3)
		yield(self, "next")
		var _err = get_tree().change_scene("res://scenes/Levels/Level2.tscn")

func _on_Dialog_skiped():
	skiped = true
	$"../MusicPlayer".play()
	$"../MusicInfo".start()
	_world_changes()

func _on_Dialog_done():
	yield(get_tree(), "idle_frame")
	emit_signal("next")
