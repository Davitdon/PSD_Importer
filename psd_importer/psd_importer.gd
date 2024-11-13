@tool
extends EditorPlugin

var my_dock : PackedScene 
var dock

var custom_file_extension = ".psd"
var allow_psd #If this is gone you can't import psd anymore

#var conversion_script = "res://addons/psd_to_png_converter.gd"

func _enter_tree():
	#For uhh something else
	allow_psd = load("res://addons/psd_importer/import_plugins/allow_psd.gd").new()
	add_import_plugin(allow_psd)
	
	#For Making a dock
	my_dock = ResourceLoader.load("res://addons/psd_importer/assets/gui/drag_psd_here.tscn")
	dock = my_dock.instantiate()
	dock.button_pressed.connect(_on_button_pressed)

	
	# Set the dock's name
	dock.name = "PSD Importer"
	# Add it to the specified dock location
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, dock)
	dock.visible = true



func _exit_tree() -> void:
	remove_control_from_docks(dock)
	remove_import_plugin(allow_psd)
	allow_psd = null

func _on_button_pressed(): #Moves back to the scene
	var editor_interface = get_editor_interface()
	var scene_dock = editor_interface.get_dock(EditorPlugin.DOCK_SLOT_LEFT_UR)

	scene_dock.raise()
