extends KinematicBody2D

var motion = Vector2(0,0)
var movementPhase: String
const PLEYERSPEED = 533
var speed1 = PLEYERSPEED
const GRAVITY = 30
const JUMPFORCE = -1153
var fall = GRAVITY
var jumpDisrupted = false
var jumpDirecton : String
var hp = 1

var currentlyPlaying = null

func _physics_process(_delta):
	if hp > 0:
		if Input.is_action_pressed("right"):
			$Sprite.flip_h = false
			_right_left_movement(speed1)
			if !is_on_floor():
				if jumpDirecton == "left":
					jumpDisrupted = true
		elif Input.is_action_pressed("left"):
			$Sprite.flip_h = true
			if !is_on_floor():
				if jumpDirecton == "right":
					jumpDisrupted = true
			_right_left_movement(-speed1)
		elif is_on_floor():
			movementPhase = "idle"
			_play("idle")
		if Input.is_action_just_pressed("jump") and is_on_floor():
			motion.y = JUMPFORCE
			jumpDisrupted = false
			if motion.x > 0:
				jumpDirecton = "right"
			elif motion.x < 0:
				jumpDirecton = "left"
			else:
				jumpDirecton = "middle"
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
func _play(animName):
	currentlyPlaying = animName
	$Sprite.play(animName)
	

func _on_fallzone_body_entered(body):
	hp = 0

func _knock_back():
	print("kncokback")
