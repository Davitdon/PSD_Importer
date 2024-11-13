@tool
extends Control

@onready var csharp_path = preload("res://addons/psd_importer/Main.cs")

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
	

"Doesn't work right now"
func _on_d_frame_pressed() -> void: #8D Frame #When your making a game and you have an omnidirectional character
	emit_signal("button_pressed")
	
	#8 Sprite2d for each body part
	pass # Replace with function body.

"Good old fasion psd (Doesn't work)"
func _on_frame_pressed() -> void: #Regular Psd style
	emit_signal("button_pressed")
	
	# Bring the dock to the front
	if path:
		var csharp = csharp_path.new()
		var output = csharp.PsdLayersToPngs(path, 0) #Type Images
		#var output: [Images, Names]
		"I need to get the name of the images somehow"
		
		
		var selection := EditorInterface.get_selection().get_selected_nodes()
		if selection.size() > 0:
			var i = 0
			for image in output: #Checks images 
				var sprite : Sprite2D = Sprite2D.new()
				var parent = selection.front()
							
				parent.add_child(sprite)
				sprite.owner = parent
				sprite.name = str(i)
				
				var image_texture = ImageTexture.create_from_image(image)
				sprite.texture = image_texture
				
				i+=1
			print("Done Making Frame")


func _on_item_pressed() -> void: #sprite2d sheet of item
	emit_signal("button_pressed")
	if path:
		var csharp = csharp_path.new()
		var images = csharp.PsdLayersToPngs(path, 0) #Type Images
		
		
		var selection := EditorInterface.get_selection().get_selected_nodes()
		if selection.size() > 0:
			var parent = selection.front()
			var a_sprite : AnimatedSprite2D = AnimatedSprite2D.new()
			a_sprite.sprite_frames = SpriteFrames.new()
			a_sprite.sprite_frames.add_animation("direction")
			
			parent.add_child(a_sprite)
			
			for image in images: #Convert Bytpe To PackedByteArray

				a_sprite.name = "Layer_Sprite"
				a_sprite.owner = parent

				var image_texture = ImageTexture.create_from_image(image)
				# Add the texture to the "direction" animation
				a_sprite.sprite_frames.add_frame("direction", image_texture)
				
			
			#Test
			var packed_data = PackedByteArray()
			packed_data.append(images[0])
			var image_texture = ImageTexture.create_from_image(images[0])
			var sprite = Sprite2D.new()
			sprite.texture = image_texture
			parent.add_child(sprite)
			sprite.owner = parent
			sprite.name = "ImageTime"
		
			#end of test
		print("Done looping")
		


	




func _on_button_pressed() -> void:
	var file_dialog: FileDialog = $FileDialog
	file_dialog.popup()
	


	"""
		0, left
		1, 34 left
		2 front
		3 34 right
		4 right
		5 34b right
		6 34b left
		7 back
		"""
