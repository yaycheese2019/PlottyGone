extends Panel
class_name PlotScene

# scene settings
var room = "box"
var is_current = false
var camera_position:Vector3
var camera_rotation:Vector3
# ui settings
var ldrag = false
var rdrag = false
var hasFocus = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func clone() -> PlotScene:
	var cln = duplicate()
	cln.room = room
	cln.camera_position = Vector3(camera_position)
	cln.camera_rotation = Vector3(camera_rotation)
	return cln

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$idx.text = "#"+str(get_index() + 1)+": "+str(custom_minimum_size.x / 100)
	$room.text = room
	
	if rdrag:
		var mpos = get_global_mouse_position()
		custom_minimum_size.x = mpos.x - global_position.x
		if custom_minimum_size.x < 10:
			custom_minimum_size.x = 10


func _on_left_button_down() -> void:
	ldrag = true

func _on_left_button_up() -> void:
	ldrag = false

func _on_right_button_down() -> void:
	rdrag = true

func _on_right_button_up() -> void:
	rdrag = false


func _on_edit_pressed() -> void:
	$inspect.play()
	$menu.position = global_position + (get_global_mouse_position() - global_position)
	$menu.position += Vector2i.UP * 200
	$menu.show()


func _on_menu_id_pressed(id: int) -> void:
	match id:
		0:
			if is_current:
				$"../../../..".cleanup()
			queue_free()
		1:
			custom_minimum_size.x = 100
		2:
			var dupe = clone()
			get_parent().add_child(dupe)
			
			get_parent().move_child(dupe, get_index()+1)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		$"../../../..".change_scene(self)
		


func _on_del_pressed() -> void:
	if is_current:
		$"../../../..".cleanup()
	queue_free()

func _on_moveleft_pressed() -> void:
	get_parent().move_child(self, get_index()-1)


func _on_moveright_pressed() -> void:
	get_parent().move_child(self, get_index()+1)
