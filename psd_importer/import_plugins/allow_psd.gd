@tool
extends EditorImportPlugin

func _get_importer_name():
	return "PSD Importer"

func _get_priority():
	return 2  

func _get_visible_name():
	return "PSD Importer"

func _get_recognized_extensions():
	return ["psd"]

func _get_save_extension():
	return "png"  # Save as PNG or any other appropriate format

func _get_resource_type():
	return "Texture"
	
func _get_preset_count():
	return 1

func _get_preset_name(preset_index):
	return "Default"

func _get_import_options(path, preset_index):
	return []

func _import(source_file, save_path, options, platform_variants, gen_files):	
	#print(source_file) #res::/path/to/.psd
	return OK
	
	
