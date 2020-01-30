extends Node2D

# Member variables
var viewport = null
var sprite = null
var viewport_sprite = null

var viewport_initial_size = Vector2()

# variables for the sprite animation
const MAX_FRAME_FOR_SPRITE = 4
const FRAME_SWITCH_TIME = 0.2
var frame_switch_timer = 0

func _ready():
	get_viewport().connect("size_changed", self, "_root_viewport_size_changed")

	viewport = get_node("Viewport")
	sprite = get_node("Sprite")
	viewport_sprite = get_node("Viewport_Sprite")

	viewport_initial_size = viewport.size

	# Assign the sprite's texture to the viewport texture
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	# Let two frames pass to make sure the screen was captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	viewport_sprite.texture = viewport.get_texture()

	set_process(true)


# Simple frame-based animation
func _process(delta):
	frame_switch_timer += delta
	if frame_switch_timer >= FRAME_SWITCH_TIME:
		frame_switch_timer -= FRAME_SWITCH_TIME
		sprite.frame += 1
	if sprite.frame > MAX_FRAME_FOR_SPRITE:
		sprite.frame = 0

# Called when the root's viewport size changes (i.e. when the window is resized).
# This is done to handle multiple resolutions without losing quality.
func _root_viewport_size_changed():
	# The viewport is resized depending on the window height.
	# To compensate for the larger resolution, the viewport sprite is scaled down.
	viewport.size = Vector2.ONE * get_viewport().size.y
	viewport_sprite.scale = Vector2.ONE * viewport_initial_size.y / get_viewport().size.y
