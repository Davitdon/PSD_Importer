#Check csproj_stuff() to see what is added to your .csproj script
@tool
extends EditorPlugin


var my_dock : PackedScene 
var dock

var custom_file_extension = ".psd"
var allow_psd #If this is gone you can't import psd anymore

#var conversion_script = "res://addons/psd_to_png_converter.gd"

func _enter_tree():
	if !csproj_stuff():
		return
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

func _on_button_pressed(): #Do something when you click a button
	return
	#I wanted to make it so that you show the Scene dock if its there
	#var editor_interface = get_editor_interface()
	#var scene_dock = editor_interface.get_dock(EditorPlugin.DOCK_SLOT_LEFT_UR)
	#scene_dock.raise()

func csproj_stuff() -> bool:
	var csproj_path = find_csproj_file()
	if csproj_path == "":
		print("Error: No .csproj file found in res://.")
		return false
	
	var csproj_content = FileAccess.get_file_as_string(csproj_path)
	var modified = false
	
	# Check for <AllowUnsafeBlocks>true</AllowUnsafeBlocks>
	csproj_content = check_and_update_csproj(csproj_content, "<AllowUnsafeBlocks>true</AllowUnsafeBlocks>", "    <AllowUnsafeBlocks>true</AllowUnsafeBlocks>", "</PropertyGroup>")
	if csproj_content != FileAccess.get_file_as_string(csproj_path):
		modified = true
	
	# Check for <PackageReference Include="System.Drawing.Common" Version="6.0.0" />
	csproj_content = check_and_update_csproj(csproj_content, '<PackageReference Include="System.Drawing.Common" Version="6.0.0" />', '    <PackageReference Include="System.Drawing.Common" Version="6.0.0" />', "</ItemGroup>")
	if csproj_content != FileAccess.get_file_as_string(csproj_path):
		modified = true
	
	# Check for <PackageReference Include="Magick.NET-Q8-AnyCPU" Version="13.8.0" />
	csproj_content = check_and_update_csproj(csproj_content, '<PackageReference Include="Magick.NET-Q8-AnyCPU" Version="13.8.0" />', '    <PackageReference Include="Magick.NET-Q8-AnyCPU" Version="13.8.0" />', "</ItemGroup>")
	if csproj_content != FileAccess.get_file_as_string(csproj_path):
		modified = true
	
	# If modifications were made, write them back to the file
	if modified:
		var file = FileAccess.open(csproj_path, FileAccess.WRITE)
		file.store_string(csproj_content)
		file.close()
		print("Modifications made to .csproj file.")
	else:
		print(".csproj file already contains the required entries.")
	
	return true

# Generalized function to find and replace specific elements in .csproj
func check_and_update_csproj(csproj_content: String, tag_to_find: String, tag_to_add: String, closing_tag: String) -> String:
	var modified = false
	
	# Check if the tag_to_find exists in the csproj content
	if csproj_content.find(tag_to_find) == -1:
		# If it doesn't exist, add the tag_to_add before the closing_tag
		if csproj_content.find(closing_tag) != -1:
			csproj_content = csproj_content.replace(closing_tag, tag_to_add + "\n" + closing_tag)
			modified = true
	
	# Return modified content if changes were made
	if modified:
		return csproj_content
	return csproj_content



func find_csproj_file() -> String:
	var dir = DirAccess.open("res://")
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break
			if !dir.current_is_dir() and file_name.ends_with(".csproj"):
				return "res://" + file_name
		dir.list_dir_end()
	return ""
