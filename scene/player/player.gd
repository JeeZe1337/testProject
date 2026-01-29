extends CharacterBody2D

const SPEED_WALK = 100.0
const SPEED = 250.0
const JUMP_VELOCITY = -450.0
const LIMIT_FALL = 1200.0
var current_speed = SPEED_WALK
var health = 5
var alive = true
var damage_area = null
var attach = false
var damage_enemy = false
var anim_damage_enemy = false
@onready var anim = $AnimatedSprite2D
@onready var ninjaEnemy = $"../../enemy/ninja_enemy"

func _physics_process(delta: float) -> void:
	var is_running = Input.is_action_pressed("shift")
	current_speed = SPEED if is_running else SPEED_WALK
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("left_click"):
		attach = true
		if velocity.y == 0:
			velocity.x = 0
		anim.play("attack_one")
		await anim.animation_finished
		attach = false
		anim_damage_enemy = false
		$Attach/CollisionAttach.set_deferred("disabled", true)
	if alive == true and attach == false:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * current_speed
			if velocity.y == 0 && is_running:
				anim.play("run")
			elif velocity.y == 0:
				anim.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED_WALK)
			if velocity.y == 0:
				anim.play("idle")
		if direction == -1:
			$Attach.scale.x = -1
			anim.flip_h = true
		elif direction == 1:
			$Attach.scale.x = 1
			anim.flip_h = false
		if velocity.y > 0:
			anim.play("fall")
		if $Inv.time_left == 0:
			if damage_area != null:
				take_damage()
				$Inv.start()
		if position.y > LIMIT_FALL:
			death()
		
	if health <= 0:
		death()
		
	move_and_slide()
	
func take_damage():
	health-= 1
	
func death():
	alive = false
	#anim.play("dead")
	#await anim.animation_finishedda
	queue_free()
	get_tree().change_scene_to_file("res://scene/menu/menu.tscn")

func _on_hit_box_body_entered(body: Node2D) -> void:
	damage_area = body

func _on_hit_box_body_exited(body: Node2D) -> void:
	if damage_area == body:
		damage_area = null

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack_one" and $AnimatedSprite2D.frame == 4:
		$Attach/CollisionAttach.set_deferred("disabled", false)
		anim_damage_enemy = true
