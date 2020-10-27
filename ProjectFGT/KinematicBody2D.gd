extends KinematicBody2D

var motion = Vector2(0,0)
var movementPhase: String
const PLEYERSPEED = 533
var speed1 = PLEYERSPEED
const GRAVITY = 30
const JUMPFORCE = -1153
var fall = GRAVITY
var x = 1

var currentlyPlaying = null

func _physics_process(_delta):
	if Input.is_action_pressed("right"):
		$Sprite.flip_h = false
		_right_left_movement(speed1)
	elif Input.is_action_pressed("left"):
		$Sprite.flip_h = true
		_right_left_movement(-speed1)
	elif is_on_floor():
		movementPhase = "idle"
		_play("idle")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		motion.y = JUMPFORCE
	_fall_physics()
	motion = move_and_slide(motion, Vector2.UP)
	motion.x = lerp(motion.x,0,1)
	

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
			motion.y += fall
			if is_on_floor():
				fall = 40
			else: 
				print(motion.y)
				print(currentlyPlaying)
				if motion.y > JUMPFORCE/2 && motion.y < -JUMPFORCE/2 :
					_play("airTop")
				elif motion.y < JUMPFORCE/2:
					_play("airUp")
				else:
					_play("airDown")

func _play(animName):
	currentlyPlaying = animName
	$Sprite.play(animName)
	
