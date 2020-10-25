extends KinematicBody2D

var motion = Vector2(0,0)
var movementPhase: String
const PLEYERSPEED = 350
var speed1 = PLEYERSPEED
const GRAVITY = 30
const JUMPFORCE = -865
var fall = GRAVITY


func _physics_process(_delta):
	
	if Input.is_action_pressed("right"):
		$Sprite.flip_h = false
		_right_left_movement(speed1)
	elif Input.is_action_pressed("left"):
		$Sprite.flip_h = true
		_right_left_movement(-speed1)
	else:
		$Sprite.play("idle")
		movementPhase = "idle"
	if Input.is_action_just_pressed("jump") and is_on_floor():
		motion.y = JUMPFORCE
	_fall_physics()
	if !is_on_floor():
		$Sprite.play("air")
	motion = move_and_slide(motion, Vector2.UP)
	motion.x = lerp(motion.x,0,1)

func _right_left_movement(rychlost):
		if is_on_floor():
			if Input.is_action_pressed("sprint"):
				$Sprite.play("sprint")
				rychlost = 1.75 * rychlost
				print(motion.x)
				movementPhase = "sprint"
			else:
				rychlost = rychlost
				movementPhase = "walk"
				$Sprite.play("walk")
		else:
			match movementPhase:
					"sprint":
						rychlost = rychlost * 1.85
					"walk":
						rychlost = rychlost
					"idle":
						rychlost = rychlost * 0.7
		motion.x = rychlost

func _fall_physics():
			if fall > 45:
				fall = 45
			fall += fall/10
			motion.y += fall
			if is_on_floor():
				speed1 = PLEYERSPEED
				fall = 35
			else:
				speed1 = 1.3 * PLEYERSPEED
