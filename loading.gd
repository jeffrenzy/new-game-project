extends Node2D

@onready var progress_holder: Control = %ProgressHolder
@onready var fill_panel: Panel = %FillPanel


func set_progress(current: float, maximum: float) -> void:
	var percent: float = clamp(current / maximum, 0.0, 1.0)

	fill_panel.size.x = progress_holder.size.x * percent
	fill_panel.size.y = progress_holder.size.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var curr_prog: float = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curr_prog = min(curr_prog+0.01, 10)
	set_progress(curr_prog, 10)
	pass
