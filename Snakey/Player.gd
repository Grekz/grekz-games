extends Area2D
signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$Monito.play()
	else:
		$Monito.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$Monito.animation = "walk"
		$Monito.flip_v = false
		# See the note below about boolean assignment.
		$Monito.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$Monito.animation = "up"
		$Monito.flip_v = velocity.y > 0
		
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _on_Player_hit():
	pass # Replace with function body.
