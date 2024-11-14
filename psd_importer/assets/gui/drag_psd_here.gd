@tool
extends Control

@onready var csharp_path = preload("res://addons/psd_importer/Main.cs")

@onready var psd_options: OptionButton = $GridContainer/VBoxContainer/HBoxContainer/psdOptions

signal button_pressed()

var path : String 

func _enter_tree():
	$FileDialog.file_selected.connect(_on_file_dialog_selected)
	get_tree().get_root().files_dropped.connect(_on_files_dropped)
	

func _exit_tree() -> void:
	get_tree().get_root().files_dropped.disconnect(_on_files_dropped)
	path = ""

func _on_file_dialog_selected(file_path: String): #converts res:// to full_path
	path = ProjectSettings.globalize_path(file_path) 

func _on_files_dropped(files): #Check if first file has .psd extension
	#check for psd
	if files[0].ends_with(".psd"):
		path = files[0]
		print(path)
	else:
		printerr("Not a .psd file")
	

func _on_import_pressed() -> void: #When you press the Import button, you can do something here
	print(psd_options.selected)
	match psd_options.selected:
		0:#Frames
			make_frames()
		1:#Flat
			make_flat()
		2:#AnimatedSprite2D
			make_animated_sprite2d()
		3:#8DFrames
			make_8d_frames()
			

"Doesn't work right now"
func make_8d_frames() -> void: #8D Frame #When your making a game and you have an omnidirectional character
	emit_signal("button_pressed")
	
	#8 Sprite2d for each body part
	pass # Replace with function body.


func make_frames() -> void: #Regular Psd style (Doesnt work properly)
	emit_signal("button_pressed")
	
	# Bring the dock to the front
	if path:
		var csharp = csharp_path.new()
		var output = csharp.PsdLayersToPngs(path, 0, '') #Type Images
		#var output: [Images, Names]
		"I need to get the name of the images somehow"
		
		
		var selection := EditorInterface.get_selection().get_selected_nodes()
		if selection.size() > 0:
			var i = 0
			for data in output: #Checks images 
				var image = data[0]
				var image_name = data[1]
				var sprite : Sprite2D = Sprite2D.new()
				var parent = selection.front()
							
				parent.add_child(sprite)
				sprite.owner = parent
				sprite.name = str(image_name)
				
				var image_texture = ImageTexture.create_from_image(image)
				sprite.texture = image_texture
				
				i+=1
			print("Done Making Frame")


func make_flat(): #Psd to Single Layer
	if path:
		var csharp = csharp_path.new()
		var output : Array = csharp.PsdToPng(path,'') #[Image, ImageName]
		var image = output[0]
		var image_name = output[1]
		print("Making %s flat" % [image_name])
		#Output : [[Image][Name]] Supposed to be this way, or a class, but its too much work
		var selection := EditorInterface.get_selection().get_selected_nodes()
		if selection.size() > 0:
			var i = 0
			var sprite : Sprite2D = Sprite2D.new()
			var parent = selection.front()
							
			parent.add_child(sprite)
			sprite.owner = parent
			sprite.name = image_name
				
			var image_texture = ImageTexture.create_from_image(image)
			sprite.texture = image_texture


func make_animated_sprite2d() -> void: #Sprite2d with a bunch of frames
	emit_signal("button_pressed")
	if path:
		var csharp = csharp_path.new()
		var output = csharp.PsdLayersToPngs(path, 0,'') #Type Images
		
		
		var selection := EditorInterface.get_selection().get_selected_nodes()
		if selection.size() > 0:
			var parent = selection.front()
			var a_sprite : AnimatedSprite2D = AnimatedSprite2D.new()
			a_sprite.sprite_frames = SpriteFrames.new()
			a_sprite.sprite_frames.add_animation("direction")
			
			parent.add_child(a_sprite)
			
			a_sprite.owner = parent
			a_sprite.name =  path.get_file()
			
			for data in output: #Convert Bytpe To PackedByteArray
				var image = data[0]
				var image_texture = ImageTexture.create_from_image(image)
				# Add the texture to the "direction" animation
				a_sprite.sprite_frames.add_frame("direction", image_texture)
				
			
		print("Done looping")


func _on_default_file_system_pressed() -> void:
	#Not important
	var my_os_path = OS.get_name()
	match OS.get_name():
		"Windows":
			my_os_path = "C:"
	#End of not important
	
	
	var file_dialog: FileDialog = $FileDialog
	var absolute_path =  my_os_path + file_dialog.current_dir #Also not important
	
	file_dialog.popup()
