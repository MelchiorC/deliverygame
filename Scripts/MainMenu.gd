extends Control

func _ready():
	$HighScoreLabel.text = "High Score: " + str(load_highscore())

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func load_highscore() -> int:
	if FileAccess.file_exists("user://score.save"):
		var file = FileAccess.open("user://score.save", FileAccess.READ)
		return file.get_32()
	return 0


func _on_exit_pressed():
	get_tree().quit()
