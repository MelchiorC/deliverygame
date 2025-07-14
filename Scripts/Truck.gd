extends Area2D

@export var package_types := ["Red", "Blue", "Green", "Yellow"]

var overlapping_bodies := []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _process(_delta):
	# Detect pickup input manually while player is still inside
	if Input.is_action_just_pressed("ui_accept"):
		for body in overlapping_bodies:
			if body.has_method("pick_package"):
				var package = package_types[randi() % package_types.size()]
				body.pick_package(package)
				if has_node("PickupParticles"):
					$PickupParticles.restart()
				print("Delivered package:", package)

func _on_body_entered(body):
	if not overlapping_bodies.has(body):
		overlapping_bodies.append(body)
		print("Body entered truck area:", body.name)

func _on_body_exited(body):
	if overlapping_bodies.has(body):
		overlapping_bodies.erase(body)
		print("Body exited truck area:", body.name)
