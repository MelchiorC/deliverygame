extends Area2D

@onready var label = $Label
@export var package_types := ["Red", "Blue", "Green", "Yellow"]
var desired_package := ""

signal package_delivered(success: bool)

var player_inside: Node = null 

func _ready():
	randomize_desired_package()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func randomize_desired_package():
	desired_package = package_types[randi() % package_types.size()]
	label.text = desired_package
	print(name, desired_package)

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = body
		print("Player entered ", name)

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
		print("Player exited ", name)

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("ui_accept"):
		if player_inside.has_method("deliver_package"):
			var result = player_inside.deliver_package(desired_package)
			emit_signal("package_delivered", result)
			if result:
				if has_node("DeliverParticles"):
					$DeliverParticles.restart()
				print("Delivered to ", name)
				randomize_desired_package()
			else:
				print("Wrong package delivered to ", name)
