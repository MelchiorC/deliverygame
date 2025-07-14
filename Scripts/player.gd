extends CharacterBody2D

@export var move_speed := 200
@export var package_label: Label
var carrying_package := ""  # Package type

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var run_particles: GPUParticles2D = $RunParticles

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# Flip sprite
	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false

	# Play animations + toggle particles
	if direction.x != 0:
		if animated_sprite.animation != "run":
			animated_sprite.play("run")
		run_particles.emitting = true
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
		run_particles.emitting = false

	# Movement
	velocity = direction * move_speed
	move_and_slide()

func pick_package(package_type: String):
	carrying_package = package_type
	if package_label:
		package_label.text = "Package: " + carrying_package
	$PickupSound.play()
	print("Picked package:", package_type)

func deliver_package(recipient_package: String) -> bool:
	var success = carrying_package == recipient_package
	if package_label:
		package_label.text = "Package: None"
	carrying_package = ""
	if success:
		$DeliverSound.play()
	return success
