extends CharacterBody2D

const SPEED_WALK = 100.0
const SPEED = 150.0
const JUMP_VELOCITY = -450.0
var current_speed = SPEED_WALK
var chase = false
@onready var anim = $AnimationNinja
var alive = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var player = $"../../player/player"
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true:
			velocity.x = direction.x * SPEED
			anim.play("run")
		else:
			velocity.x = 0
			anim.play("idle")
		if direction.x < 0:
			anim.flip_h = true
		else:
			anim.flip_h = false

	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = true

func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = false

func _on_deatch_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.velocity.y -= 200
		death()
		
func _on_damage_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if alive == true:
			body.health -= 1
		
func death():
	alive = false
	velocity.x = 0
	anim.play("dead")
	await anim.animation_finished
	queue_free()
