#!/bin/bash

# Syntax
#
#	[command]	[options]	's|original_hex_colour_code|intended_hex_colour_code|g' /path/to/folder/icons/*
#	sed 		-i 
#	
#	Notes:	[adding * will change all files in the directory]

sed -i 's|#f2f2f2|#f2f2f2|g' /home/uri/Documentos/Script\ arena/color-script/*