extends Node

@onready var timer: Timer = $Timer
@onready var score_label: Label = $UI/ScoreLabel
@onready var time_label: Label = $UI/TimerLabel
@onready var game_over: Control = $UI/GameOverPopup

var score: int = 0
var time_left: float = 5.0
var game_ended := false

func _ready():
	score = 0
	time_left = 5.0
	game_ended = false
	timer.start()
	score_label.text = "Score: 0"
	time_label.text = "Time: " + str(int(time_left))

	for recipient in get_tree().get_nodes_in_group("recipients"):
		recipient.connect("package_delivered", Callable(self, "_on_recipient_package_delivered"))

func _process(delta: float) -> void:
	if game_ended:
		return

	time_left -= delta
	if time_left < 0:
		time_left = 0

	time_label.text = "Time: " + str(int(time_left))

	if time_left <= 0 and not game_ended:
		end_game()

func _on_recipient_package_delivered(success):
	if success:
		score += 1
		score_label.text = "Score: " + str(score)

func end_game() -> void:
	print("END GAME CALLED")
	game_ended = true
	timer.stop()
	game_over.show()

	var high_score = load_highscore()
	if score > high_score:
		save_highscore(score)

	$UI/GameOverPopup/FinalScore.text = "Your Score: " + str(score)
	$UI/GameOverPopup/HighScore.text = "High Score: " + str(load_highscore())

func save_highscore(value: int) -> void:
	var file = FileAccess.open("user://score.save", FileAccess.WRITE)
	if file:
		file.store_32(value)

func load_highscore() -> int:
	if FileAccess.file_exists("user://score.save"):
		var file = FileAccess.open("user://score.save", FileAccess.READ)
		if file:
			return file.get_32()
	return 0
