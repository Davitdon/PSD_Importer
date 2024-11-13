using Godot;
using System;
using System.IO;
using PhotoshopFiles;

using System.Drawing; //Get rectangle??
using System.Collections.Specialized;
using System.Collections.Generic;

using System.Reflection; //Debugging tool



public partial class Main : Node2D
{
	public Godot.Collections.Array<Godot.Image> PsdLayersToPngs(string psdPath, int type_of_psd = 0)// 0 is Frame, 1 is Item, 2,is 8D
	{
		// Paths for the PSD file and output directory
		string outputDir = ProjectSettings.GlobalizePath("res://psd_layers_output/");
		
		var layerDataList = new Godot.Collections.Array<Godot.Image>();
		
		// Ensure the output directory exists
		if (!System.IO.Directory.Exists(outputDir))
			System.IO.Directory.CreateDirectory(outputDir);

		PhotoshopFiles.PsdFile psd = new PhotoshopFiles.PsdFile();
		psd.Load(psdPath);
		
		/*Future me
		Iterate through the layers find the biggest layer, and that is the background,
		For now I'll just use layer 0 as the biggest layer 
		*/
		bool is_bg = false; //background  
		System.Drawing.Image bg_layer = null;
		int bg_layer_height = 0;
		int bg_layer_width = 0;
		
		for (int j = 0; j < psd.Layers.Count; j++)
			{
				System.Drawing.Image layer = ImageDecoder.DecodeImage(psd.Layers[j]);
				//InspectLayerProperties(psd);
				//GD.Print(layer.FrameDimensionsList);
				//InspectLayerProperties(psd.FrameDimensionsList); 

				if (layer == null)
				{
					GD.PrintErr($"Layer {j} is null.");
					continue; // Skip null layers
				}
				
				/*
				if type_of_psd == 1 #Item
				Get the images, put them in order
				It reads the layer name if it has:
				left, west (name file left+name)
				34 left, front left, forward left (it shows 34_left+file_name)
				front, forward (it shows front)
				34 right, front right, forward right, 34 FR (it shows 34_right)
				right, east (it shows right)
				34b right, back right, south east (shows 34b_right)
				34b left, back left, south west (shows 34b_left)

				back, behind, south (it shows back)
				*/
				
				using (MemoryStream memoryStream = new MemoryStream())
				{
					// Save the layer image to the memory stream as PNG
					layer.Save(memoryStream, System.Drawing.Imaging.ImageFormat.Png);

					// Get the PNG byte data from the memory stream
					byte[] pngData = memoryStream.ToArray();

					// Create a Godot Image and load the PNG data into it
					Godot.Image godotImage = new Godot.Image(); //In gdscript cove
					godotImage.LoadPngFromBuffer(pngData); // Use pngData instead of pngStream.ToArray()
					
					
					
					// Add the texture to the layerDataList
					layerDataList.Add(godotImage);

					// Save to disk
					string safeLayerName = $"{j}_" + string.Join("_", psd.Layers[j].Name.Split(Path.GetInvalidFileNameChars()));
					string outputPath = Path.Combine(outputDir, $"{safeLayerName}.png");

					File.WriteAllBytes(outputPath, pngData); // Write byte array to file
				}
			}
		GD.Print("it work?!");
		return layerDataList;
		//I want more information I want to get the x and y position of where to place the image, for each layer
		//Do you need the scripts information or can you find it out online, or already know?
	}
	

	public void InspectLayerProperties(object layer)
	{
		// Get the type of the layer object
		Type layerType = layer.GetType();
		
		// Get all public properties of the layer
		PropertyInfo[] properties = layerType.GetProperties();
		
		// Print the names of all properties
		foreach (var property in properties)
		{
			GD.Print($"Property: {property.Name}");
		}

		// If you want to access specific properties, you can do so like this
		var specificProperty = layerType.GetProperty("SomeProperty");  // Replace "SomeProperty" with the property you're interested in
		if (specificProperty != null)
		{
			var value = specificProperty.GetValue(layer);
			GD.Print($"SomeProperty value: {value}");
		}
	}
}
