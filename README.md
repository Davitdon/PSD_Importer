Dragging and dropping psds from file system doesn't work.
I was too lazy to find out the solution

Created a PSD Importer Dock

Project>Project Settings> Plugins

First choose the root node
Second: Go to the PSD_Importer Dock
Third: Drag&Drop .psd or click CheckFileSystem and double click .psd
Fourth: Choose Import Option
Fifth: Click Import

Problems: I need to find the offset of an image layer, in order to properly arrange Frames (Check Photoshop, it may help)

Uhh open source c# psd converters
https://www.imagemagick.org
something else I forgot

Yeah I need to find the transform and depth in the source file, if you find it, I can update the psd_importer, to make frames work properly
