AutoImageFlags MIPMAPPEDIMAGE
AutoMidHandle True 

SetBlend ALPHABLEND
Global grass_img:TImage = LoadImage2:TImage("assets\tile\grass.png")
Global grass_cc_img:TImage = LoadImage2:TImage("assets\tile\grass_concave.png")
Global grass_cv_img:TImage = LoadImage2:TImage("assets\tile\grass_convex.png")

Global dirt_img:TImage = LoadImage2:TImage("assets\tile\dirt.png")

Global water_img:TImage = LoadAnimImage2:TImage("assets\tile\water.png",32,32,0,4)

Global sand_img:TImage = LoadImage2:TImage("assets\tile\sand.png")
Global path_img:TImage = LoadImage2:TImage("assets\tile\path.png")

Global path_up_img:TImage = LoadImage2:TImage("assets\tile\path_up.png")


Global spawn_img:TImage = LoadImage2:TImage("assets\tile\spawn.png")

Global inventory_img:TImage = LoadImage2:TImage("assets\inventory.png",MASKEDIMAGE)

SetImageHandle inventory_img,0,0


Global bush_img:TImage = LoadImage2:TImage("assets\tile\bush.png")
Global tree_trunk_img:TImage = LoadImage2:TImage("assets\tile\tree_trunk.png")
Global tree_trunk_top_img:TImage = LoadImage2:TImage("assets\tile\tree_trunk_top.png")

Global title_img:TImage = LoadImage2:TImage("assets\title.png")

Global unknown_img:TImage = LoadImage2:TImage("assets\tile\missing.png")

Global weapon_img:TImage = LoadImage2:TImage("assets\item\gun.png")
Global fruit_img:TImage = LoadImage2:TImage("assets\item\fruit.png")


Global char_img:TImage = LoadAnimImage2:TImage("assets\character\character.png",28,18,0,2)
Global eyes0_img:TImage = LoadImage2:TImage("assets\character\eyes0.png")
Global eyes1_img:TImage = LoadImage2:TImage("assets\character\eyes1.png")
Global eyes2_img:TImage = LoadImage2:TImage("assets\character\eyes2.png")
Global eyes3_img:TImage = LoadImage2:TImage("assets\character\eyes3.png")
Global eyes4_img:TImage = LoadImage2:TImage("assets\character\eyes4.png")



Global smile0_img:TImage = LoadImage2:TImage("assets\character\smile0.png")
Global smile1_img:TImage = LoadImage2:TImage("assets\character\smile1.png")
Global smile2_img:TImage = LoadImage2:TImage("assets\character\smile2.png")
Global smile3_img:TImage = LoadImage2:TImage("assets\character\smile3.png")
Global smile4_img:TImage = LoadImage2:TImage("assets\character\smile4.png")


Global gun_img:TImage = LoadImage2:TImage("assets\item\gun.png")


Global button_img:TImage = LoadImage2:TImage("assets\button.png")

Global tester_img:TImage = LoadImage2:TImage("assets\tester.png")

AutoMidHandle False

Global cursor1_img:TImage = LoadImage2:TImage("assets\cursor1.png")
SetImageHandle cursor1_img,0,0

Global cursor2_img:TImage = LoadImage2:TImage("assets\cursor2.png")

Global cursor3_img:TImage = LoadImage2:TImage("assets\cursor3.png")
SetImageHandle cursor3_img,6,0


Global font = LoadImageFont2("assets\font\Deadly Advance.ttf",14)

Global font2 = LoadImageFont2("assets\font\Deadly Advance.ttf",18)


''Global char_img:TImage = LoadAnimImage2:TImage("assets\character\character.png",22,23,0,8)

MidHandleImage char_img

Function LoadImage2:TImage(url:Object,flags = -1)
	If LoadImage(url,flags) <> Null Then
		create_console_msg("Loaded image "+String(url),"success")
		Return LoadImage(url,flags)
	Else
		create_console_msg("Couldn't load image '"+String(url)+"', file not found","error")
		Return LoadImage("assets\tile\missing.png")
	EndIf
EndFunction

Function LoadAnimImage2:TImage(url:Object,cell_width,cell_height,first_cell,cell_count,flags = -1)
	If LoadAnimImage(url,cell_width,cell_height,first_cell,cell_count,flags) <> Null Then
		create_console_msg("Loaded image "+String(url),"success")
		Return LoadAnimImage(url,cell_width,cell_height,first_cell,cell_count,flags)
	Else
		create_console_msg("Couldn't load image '"+String(url)+"', file not found","error")
	EndIf
EndFunction

Function LoadImageFont2:TimageFont(url:Object,size,style = SMOOTHFONT)
	If LoadImageFont(url:Object,size,style = SMOOTHFONT) <> Null Then
		create_console_msg("Loaded font "+String(url),"success")
		Return LoadImageFont(url:Object,size,style = SMOOTHFONT)
	Else
		create_console_msg("Couldn't load font '"+String(url)+"', file not found","error")
	EndIf
EndFunction


Function LoadMap:Int[,](dir:Object,sizex = 32,sizey = 32)	
	Local f = OpenStream(dir)
	Local temp:String
	Local count:Int
	Local row:Int
	Local array[sizex,sizey]
	
	If f = Null Then 
		create_console_msg("Error loading level '"+String(dir)+"'","error")
		Return
	Else
		If Right(String(dir),4) = ".lvl" Or Right(String(dir),4) = ".stf" Then
			While Not Eof(f)
				temp = ReadLine(f)
				
				For i = 0 To Len(temp)
					If findchar(temp,i) <> "," Then
						array[i/2,row] = Int(findchar(temp,i))
					EndIf
				Next
				row = row + 1
			Wend
			CloseStream(f)
		Else
			create_console_msg("Error loading level '"+String(dir)+"'","error")
		
			For x = 0 To sizex-1
				For y = 0 To sizey-1
					array[x,y] = -1
				Next
			Next
			
			Return array
		EndIf
	EndIf

	create_console_msg("Loaded level "+String(dir)+"","success")
	Return array
EndFunction
