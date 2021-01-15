extends KinematicBody2D

var motion = Vector2(0,0)
var movementPhase: String
const PLEYERSPEED = 533
var airInertia = 0
const GRAVITY = 30
const JUMPFORCE = -1153
var fall = GRAVITY
var jumpDisrupted = false
var jumpDirecton : String
var hp = 1
var isAttacking: bool = false
var direction: int = 1

var currentlyPlaying = null

func _physics_process(_delta):
	if hp > 0:
		
		if Input.is_action_just_pressed("LMB") && !isAttacking:
			if is_on_floor():
				motion.x = 0
				_play("lightAtt1")
				isAttacking = true
		elif Input.is_action_just_pressed("RMB") && !isAttacking:
			if is_on_floor():
				motion.x = 0
				_play("lightAtt2")
				isAttacking = true
		elif Input.is_action_pressed("right") && !isAttacking:
			_flip_player_right()
			_right_left_movement(PLEYERSPEED)
			if !is_on_floor():
				if jumpDirecton == "left":
					jumpDisrupted = true
		elif Input.is_action_pressed("left") && !isAttacking:
			_flip_player_left()
			if !is_on_floor():
				if jumpDirecton == "right":
					jumpDisrupted = true
			_right_left_movement(-PLEYERSPEED)
		elif is_on_floor() && !isAttacking:
			movementPhase = "idle"
			_play("idle")
		else:
			_jump_inertia()
			
		if Input.is_action_just_pressed("jump") && is_on_floor() && !isAttacking:
			_jump_physics()

		_fall_physics()
		motion = move_and_slide(motion, Vector2.UP)
		motion.x = lerp(motion.x,0,1)
	else:
		get_tree().reload_current_scene()






func _right_left_movement(rychlost):
		if is_on_floor():
			if Input.is_action_pressed("sprint"):
				rychlost = 1.53 * rychlost
				movementPhase = "sprint"
				_play("sprint")
			else:
				rychlost = rychlost
				movementPhase = "walk"
				_play("walk")
		else:
			if jumpDisrupted:
				rychlost = rychlost * 0.8
			else:
				match movementPhase:
					"sprint":
						rychlost = rychlost * 1.83
					"walk":
						rychlost = rychlost
					"idle":
						rychlost = rychlost * 0.8
		motion.x = rychlost

func _fall_physics():
			if fall > 53:
				fall = 53
			fall += fall/10

			if is_on_floor():
				fall = 40

			else: 
				if motion.y > JUMPFORCE/2 && motion.y < -JUMPFORCE/2 :
					_play("airTop")
				elif motion.y < JUMPFORCE/2:
					_play("airUp")
				else:
					_play("airDown")

			motion.y += fall


func _jump_physics():
	motion.y = JUMPFORCE
	jumpDisrupted = false
	if motion.x > 0:
		jumpDirecton = "right"
	elif motion.x < 0:
		jumpDirecton = "left"
	else:
		jumpDirecton = "middle"



func _jump_inertia():
	if is_on_floor():
		airInertia = 0
	else:
		if !jumpDisrupted:
			match jumpDirecton:
				"middle":
					airInertia = 0
				"right":
					airInertia = PLEYERSPEED
				"left":
					airInertia = -PLEYERSPEED
			if movementPhase == "sprint":
				airInertia *= 1.53
			motion.x = airInertia


func _flip_player_right():
	if direction != 1:
		direction = 1
		scale.x = -1
	
	
func _flip_player_left():
	if direction != -1:
		direction = -1
		scale.x = -1

func _play(animName):
	$AnimationPlayer.play(animName)
	

func _on_fallzone_body_entered(body):
	hp = 0

func _knock_back():
	print("kncokback")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "lightAtt1" || "lightAtt2":
		isAttacking = false

func _hit_player():
	hp -= 1
