extends CharacterBody2D

@export var move_speed := 200
var carrying_package := ""  # Package type

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity = direction * move_speed
	move_and_slide()

func pick_package(package_type: String):
	if carrying_package == "":
		carrying_package = package_type
		print("Picked package:", package_type)

func deliver_package(recipient_package: String) -> bool:
	if carrying_package == recipient_package:
		carrying_package = ""
		print("Correct delivery!")
		return true
	else:
		print("Wrong delivery! Dropping package:", carrying_package)
		carrying_package = ""
		return false
