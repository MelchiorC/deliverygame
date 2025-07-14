extends Area2D

@export var package_types := ["Red", "Blue", "Green", "Yellow"]

var overlapping_bodies := []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		for body in overlapping_bodies:
			if body.has_method("pick_package"):
				var new_package = get_different_package(body.carrying_package)
				body.pick_package(new_package)

				if has_node("PickupParticles"):
					$PickupParticles.restart()

				print("Given new package:", new_package)

func get_different_package(current: String) -> String:
	var filtered = package_types.filter(func(p): return p != current)
	if filtered.is_empty():
		return current
	return filtered[randi() % filtered.size()]

func _on_body_entered(body):
	if not overlapping_bodies.has(body):
		overlapping_bodies.append(body)
		print("Body entered truck area:", body.name)

func _on_body_exited(body):
	if overlapping_bodies.has(body):
		overlapping_bodies.erase(body)
		print("Body exited truck area:", body.name)
