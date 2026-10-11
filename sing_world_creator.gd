extends Node2D

@onready var world_options: Button = %WorldOptions

@onready var mode_select: Button = %ModeSelect
@onready var mode_description: Label = %ModeDescription

@onready var world_name_enter: TextEdit = %WorldNameEnterer
@onready var save_place: Label = %SavePlace

@onready var main_panel: Panel = %MainPanel
@onready var more_panel: Panel = %MorePanel

# this is the world data the player is currently making
var world_data := {
	"name": "My World",
	"mode": "Survival",
	"date": "",
	"seed": "",
	"generate_structures": true,
	"world_type": "Normal",
	"allow_cheats": false,
	"bonus_chest": false,
}

var game_modes := {
	"Casual": "A relaxed world with fewer dangers and no pressure.",
	"Survival": "The standard mode: explore, survive, and progress normally.",
	"Hardcore": "A difficult mode with harsher hazards and permanent consequences.",
	"Creative": "Build freely with unrestricted resources and movement.",
}


func get_next_mode() -> String:
	var current_selected_mode = world_data["mode"]
	var mode_names: Array = game_modes.keys()
	var current_index: int = mode_names.find(current_selected_mode)

	current_index += 1

	# Go back to the first mode after the last one.
	if current_index >= mode_names.size():
		current_index = 0

	return mode_names[current_index]

func get_current_date_string() -> String:
	var date_time := Time.get_datetime_dict_from_system()

	var hour_12: int = date_time.hour % 12
	if hour_12 == 0:
		hour_12 = 12

	var am_pm := "AM" if date_time.hour < 12 else "PM"

	return "(%d/%d/%02d %d:%02d %s)" % [
		date_time.month,
		date_time.day,
		date_time.year % 100,
		hour_12,
		date_time.minute,
		am_pm,
	]

func toggle_more_panel(on: bool) -> void:
	if on:
		main_panel.hide()
		more_panel.show()
	else:
		main_panel.show()
		more_panel.hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_more_panel(false)
	world_name_enter.text = world_data["name"]
	save_place.text = "Will be saved in: " + world_data["name"]
	mode_select.text = "Mode: " + world_data["mode"]
	mode_description.text = game_modes[world_data["mode"]]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_create_button_pressed() -> void:
	world_data["date"] = world_data["name"] + " " + get_current_date_string()
	PlayerData.worlds.append(world_data)
	get_tree().change_scene_to_file("res://sing_world_list.tscn")

func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://sing_world_list.tscn")

func _on_world_name_enterer_text_changed() -> void:
	var world_name = world_name_enter.text
	save_place.text = "Will be saved in: " + world_name
	world_data["name"] = world_name


func _on_mode_select_pressed() -> void:
	var next_mode = get_next_mode()
	world_data["mode"] = next_mode
	mode_select.text = "Mode: " + world_data["mode"]
	mode_description.text = game_modes[world_data["mode"]]
	


func _on_done_button_pressed() -> void:
	toggle_more_panel(false)
	pass # Replace with function body.


func _on_world_options_pressed() -> void:
	toggle_more_panel(true)
	pass # Replace with function body.
