extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_dead: bool = false
const BLOCK_STATE_FALLING = 0
const BLOCK_STATE_LOCKED = 1
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var hell_music: AudioStreamPlayer2D = $HellMusic
@onready var purgatotry_heaven_music: AudioStreamPlayer2D = $PurgatotryHeavenMusic
var is_music_playing = false
var has_entered_purgatory = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if global_position.y <= -1750:
		await get_tree().create_timer(0.3).timeout
		get_tree().change_scene_to_file("res://scenes/game_end.tscn")
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	if global_position.y < -640 and not has_entered_purgatory:
		is_music_playing = false
		has_entered_purgatory = true
		hell_music.stop()

	if not is_music_playing:
		if global_position.y > -640:
			hell_music.play()
			is_music_playing = true
		if global_position.y < -640:
			purgatotry_heaven_music.play()
			is_music_playing = true
			
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if "current_state" in collider:
			
			if collider.current_state == BLOCK_STATE_FALLING:
				print("Touched a falling block - DIE")
				die()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0:
		$AnimationPlayer.flip_h = true
	elif direction < 0:
		$AnimationPlayer.flip_h = false
		
	

	move_and_slide()

func die():
	if is_dead: return
	is_dead = true
	print("Game Over")
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_hell_music_finished() -> void:
	is_music_playing = false


func _on_purgatotry_heaven_music_finished() -> void:
	is_music_playing = false
