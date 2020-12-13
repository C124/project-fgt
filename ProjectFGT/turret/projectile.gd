extends KinematicBody2D

var velocity = Vector2()
export var speed_y = -300
export var speed_x = 0
#export var point_of_detroy = 700

func _ready():
	print("Shooting projectile")
	velocity.y = speed_y
	velocity.x = speed_x



func _physics_process(delta):
#	if position.y < -point_of_detroy:
#		queue_free()
	move_and_slide(velocity)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		
		# pro přidání dalšího objektu interakce použijte daní formát -> || is název_objektu
		if collision.collider is KinematicBody2D || collision.collider is TileMap:
			queue_free()
			
