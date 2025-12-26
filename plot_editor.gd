extends Control

var plot_scene = preload("res://plot_scene.tscn")
var curScene:PlotScene
var curRoom
var movecam
@onready var camera = $"../Camera3D"

static var roomList = [
	"box",
	"dummy",
	"platform",
	"shapes",
]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for room in roomList:
		$menu/Rooms/ItemList.add_item(room)

func _on_scene_add_pressed() -> void:
	var s
	var hb = $Panel/ScrollContainer/HBoxContainer
	if hb.get_child_count() > 0:
		s = hb.get_child(hb.get_child_count() - 1).clone()
	else:
		s = plot_scene.instantiate()
	
	hb.add_child(s)
	change_scene(s)
	$scene_create.play()

func cleanup():
	if curRoom:
		curRoom.queue_free()

func _process(delta: float) -> void:
	if curRoom:
		$blank.visible = false
	else:
		$blank.visible = true
	
	if movecam:
		var move = Vector3()
		move.x = Input.get_axis("left", "right")
		move.z = Input.get_axis("forward", "back")
		move = move.rotated(Vector3.RIGHT, camera.rotation.x)
		move = move.rotated(Vector3.UP, camera.rotation.y)
		
		camera.position += move * 10 * delta
	
	if curScene:
		curScene.camera_position = camera.position
		curScene.camera_rotation = camera.rotation
	

func _on_scene_clear_pressed() -> void:
	$confirm_scene_clear.show()


func _on_confirm_scene_clear_confirmed() -> void:
	for n in $Panel/ScrollContainer/HBoxContainer.get_children():
		n.queue_free()
	cleanup()
	curScene = null
	curRoom = null

func change_scene(to:PlotScene):
	
	if curScene:
		curScene.is_current = false
	curScene = to
	cleanup()
	
	to.is_current = true
	
	var loaded:PackedScene = load("res://rooms/"+to.room+".tscn")
	if !loaded: return
	
	var created = loaded.instantiate()
	created.name = "room"
	add_child(created)
	curRoom = created
	
	camera.position = curScene.camera_position
	camera.rotation = curScene.camera_rotation


func _on_item_list_item_activated(index: int) -> void:
	if !curScene: return
	$scene_change.play()
	curScene.room = $menu/Rooms/ItemList.get_item_text(index)
	change_scene(curScene)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			movecam = event.is_pressed()
			
			if movecam:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	if movecam and event is InputEventMouseMotion:
		camera.rotation_degrees.y -= event.relative.x
		camera.rotation_degrees.x -= event.relative.y


func _on_scene_blank_pressed() -> void:
	var s = plot_scene.instantiate()
	$Panel/ScrollContainer/HBoxContainer.add_child(s)
	change_scene(s)
	$scene_create.play()
