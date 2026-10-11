extends Node2D

@onready var play_button: Button = %PlayWorldButton
@onready var rename_button: Button = %RenameWorldButton
@onready var delete_button: Button = %DeleteWorldButton
@onready var world_but_templ: Button = %WorldButtonTemplate
@onready var world_list: VBoxContainer = %WorldList
@onready var main_panel: Panel = %MainPanel
@onready var renaming_panel: Panel = %RenamingPanel
@onready var world_name_enterer: TextEdit = %WorldNameEnterer

var selected_world_index: int = -1
var world_button_group: ButtonGroup = ButtonGroup.new()

func enable_world_buttons(enabled: bool) -> void:
	play_button.disabled = not enabled
	rename_button.disabled = not enabled
	delete_button.disabled = not enabled

func _on_world_button_toggled(is_selected: bool, index: int) -> void:
	if is_selected:
		selected_world_index = index
		print("Selected world index: ", selected_world_index)
		print(PlayerData.worlds[selected_world_index])
		enable_world_buttons(true)
	else:
		enable_world_buttons(false)

func make_world_buttons() -> void:
	for child in world_list.get_children():
		child.queue_free()
	
	selected_world_index = -1

	for index in PlayerData.worlds.size():
		var world = PlayerData.worlds[index]
		var world_button: Button = world_but_templ.duplicate()
		world_button.show()

		world_button.toggle_mode = true
		world_button.button_group = world_button_group

		# stores matching list index on the button itself
		world_button.set_meta("world_index", index)

		# sends matching index into the function 
		world_button.toggled.connect(_on_world_button_toggled.bind(index))

		var name_label: Label = world_button.get_node("VBoxContainer/Name")
		var date_label: Label = world_button.get_node("VBoxContainer/Date")
		var mode_label: Label = world_button.get_node("VBoxContainer/Mode")

		name_label.text = world["name"]
		date_label.text = str(world.get("date", "Unknown date"))
		mode_label.text = world["mode"]

		world_list.add_child(world_button)

		if index == 0:
			world_button.button_pressed = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_but_templ.visible = false
	renaming_panel.hide()
	main_panel.show()
	enable_world_buttons(false)
	make_world_buttons()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cancel_pressed() -> void:
	get_tree().change_scene_to_file("res://menus.tscn")


func _on_create_new_world_pressed() -> void:
	get_tree().change_scene_to_file("res://sing_world_creator.tscn")


func _on_delete_world_button_pressed() -> void:
	if selected_world_index >= 0:
		PlayerData.worlds.remove_at(selected_world_index)
		make_world_buttons()


func _on_re_create_pressed() -> void:
	if selected_world_index >= 0:
		var copied_world: Dictionary = PlayerData.worlds[selected_world_index].duplicate(true)
		PlayerData.worlds.append(copied_world)
		make_world_buttons()





func toggle_renaming_panel(on: bool) -> void:
	if on:
		main_panel.hide()
		renaming_panel.show()
	else:
		main_panel.show()
		renaming_panel.hide()

var proposed_name: String = ""
func _on_rename_world_button_pressed() -> void:
	if selected_world_index >= 0:
		proposed_name = PlayerData.worlds[selected_world_index]["name"]
		world_name_enterer.text = proposed_name
		toggle_renaming_panel(true)
	pass # Replace with function body.

func _on_world_name_enterer_text_changed() -> void:
	proposed_name = world_name_enterer.text
	pass # Replace with function body.

func _on_rename_button_pressed() -> void:
	PlayerData.worlds[selected_world_index]["name"] = proposed_name
	make_world_buttons()
	toggle_renaming_panel(false)
	pass # Replace with function body.

func _on_cancel_rename_button_pressed() -> void:
	toggle_renaming_panel(false)
	pass # Replace with function body.



func _on_play_world_button_pressed() -> void:
	get_tree().change_scene_to_file("res://loading.tscn")
	pass # Replace with function body.
