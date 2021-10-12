''Title screen

Global menuExited = False

''HideMouse()

Global titlescale:Float = 4


SetImageFont font

Type button
	Field x
	Field y
	Field width
	Field height
	Field t:String
	Field active
	Field clicked
EndType

Type window
	Field x
	Field y
	Field width
	Field height
	Field title:String
	Field visible	
EndType

Type slider
	Field x
	Field y
	Field width
	Field height
	Field slider_x
	Field slider_y
	Field dragging
	Field visible
EndType

Global button_list:TList = New TList
Global window_list:TList = New TList
Global slider_list:TList = New TList


Global option_window:window = New window
option_window.x = 180
option_window.y = 150
option_window.width = 300
option_window.height = 400
option_window.title = "Settings"

window_list.addlast(option_window)

Global server_window:window = New window
server_window.x = 180
server_window.y = 150
server_window.width = 300
server_window.height = 400
server_window.title = "Multiplayer Servers"

window_list.addlast(server_window)

Global editor_window:window = New window
editor_window.x = 180
editor_window.y = 150
editor_window.width = 300
editor_window.height = 400
editor_window.title = "Character Editor"

window_list.addlast(editor_window)


Global chareditor:button = New button
chareditor.x = 10
chareditor.y = 260
chareditor.t = "Edit Character"
chareditor.width = TextWidth(chareditor.t)+30
chareditor.height = TextHeight(chareditor.t)+4
chareditor.active = True

button_list.addlast(chareditor)

Global playbutton:button = New button
playbutton.x = 10
playbutton.y = 200
playbutton.t = "Play"
playbutton.width = TextWidth(chareditor.t)+30
playbutton.height = TextHeight(chareditor.t)+4
playbutton.active = True

button_list.addlast(playbutton)


Global multiplayer:button = New button
multiplayer.x = 10
multiplayer.y = 230
multiplayer.t = "Join Server"
multiplayer.width = TextWidth(chareditor.t)+30
multiplayer.height = TextHeight(chareditor.t)+4
multiplayer.active = True

button_list.addlast(multiplayer)


Global options:button = New button
options.x = 10
options.y = 290
options.t = "Settings"
options.width = TextWidth(chareditor.t)+30
options.height = TextHeight(chareditor.t)+4
options.active = True

button_list.addlast(options)


Global exitbutton:button = New button
exitbutton.x = 10
exitbutton.y = 320
exitbutton.t = "Exit"
exitbutton.width = TextWidth(chareditor.t)+30
exitbutton.height = TextHeight(chareditor.t)+4
exitbutton.active = True

button_list.addlast(exitbutton)


Global mousestate = 0

SetClsColor 135,206,250

HideMouse()


Global smile_selected = 0
Global eyes_selected = 0
Global name_selected:String = "Player"

Global selected_r = Rand(0,255)
Global selected_g = Rand(0,255)
Global selected_b = Rand(0,255)


Global red_slider:slider = New slider
red_slider.x = editor_window.x+5
red_slider.y = editor_window.y+35
red_slider.width = 270
red_slider.height = 15
red_slider.visible = False
red_slider.slider_x = red_slider.x+selected_r

slider_list.addlast(red_slider)

Global green_slider:slider = New slider
green_slider.x = editor_window.x+5
green_slider.y = editor_window.y+70
green_slider.width = 270
green_slider.height = 15
green_slider.visible = False
green_slider.slider_x = green_slider.x+selected_g

slider_list.addlast(green_slider)

Global blue_slider:slider = New slider
blue_slider.x = editor_window.x+5
blue_slider.y = editor_window.y+105
blue_slider.width = 270
blue_slider.height = 15
blue_slider.visible = False
blue_slider.slider_x = blue_slider.x+selected_b

slider_list.addlast(blue_slider)




Global left_smile:button = New button
left_smile.t = "<"
left_smile.width = TextWidth(left_smile.t)+30
left_smile.height = TextHeight(left_smile.t)+4
left_smile.x = editor_window.x
left_smile.y = editor_window.y+editor_window.height/2
left_smile.active = False

button_list.addlast(left_smile)

Global right_smile:button = New button
right_smile.t = ">"
right_smile.width = TextWidth(right_smile.t)+30
right_smile.height = TextHeight(right_smile.t)+4
right_smile.x = editor_window.x+editor_window.width-right_smile.width
right_smile.y = editor_window.y+editor_window.height/2
right_smile.active = False

button_list.addlast(right_smile)

Global left_eyes:button = New button
left_eyes.t = "<"
left_eyes.width = TextWidth(left_eyes.t)+30
left_eyes.height = TextHeight(left_eyes.t)+4
left_eyes.x = editor_window.x
left_eyes.y = editor_window.y+editor_window.height/2-30
left_eyes.active = False

button_list.addlast(left_eyes)

Global right_eyes:button = New button
right_eyes.t = ">"
right_eyes.width = TextWidth(right_eyes.t)+30
right_eyes.height = TextHeight(right_eyes.t)+4
right_eyes.x = editor_window.x+editor_window.width-right_eyes.width
right_eyes.y = editor_window.y+editor_window.height/2-30
right_eyes.active = False

button_list.addlast(right_eyes)


Global resume_game:button = New button
resume_game.x = 10
resume_game.y = 200
resume_game.t = "Resume Game"
resume_game.width = TextWidth(chareditor.t)+30
resume_game.height = TextHeight(chareditor.t)+4
resume_game.active = False


button_list.addlast(resume_game)


Global smile_count = 4
Global eyes_count = 4

''========================
While Not menuExited
	Cls
	mousestate = 0
		
	SetColor 255,255,255
	DrawImage tester_img,w/2,h/2

	SetScale titlescale,titlescale
	DrawImage title_img,titlescale*ImageWidth(title_img)/2,titlescale*ImageHeight(title_img)/2
	SetScale 1,1
		
	
	handlewindows()
	handle_menu_buttons()
	handle_sliders()
	
	If editor_window.visible Then 
		character_editor()
		left_smile.active = True		
		right_smile.active = True
		left_eyes.active = True		
		right_eyes.active = True
		
		red_slider.visible = True
		green_slider.visible = True
		blue_slider.visible = True
	Else
		left_smile.active = False
		right_smile.active = False
		left_eyes.active = False		
		right_eyes.active = False

		red_slider.visible = False
		green_slider.visible = False
		blue_slider.visible = False
	EndIf
	
	
	Select mousestate
		Case 0
			DrawImage cursor1_img,MouseX(),MouseY()
		Case 1
			DrawImage cursor2_img,MouseX(),MouseY()
		Case 2
			DrawImage cursor3_img,MouseX(),MouseY()
	EndSelect
	
	
	Flip
Wend
''========================

editor_window.visible = False
server_window.visible = False
option_window.visible = False

multiplayer.active = False
playbutton.active = False
exitbutton.active = False
options.active = False
chareditor.active = False

FlushMouse()
FlushKeys()

Function handle_sliders()
	For s:slider = EachIn slider_list
		
		If s.visible Then 

			DrawRect2 s.x,s.y,s.width,s.height,3,150,150,150
			
			SetColor 200,200,200
			DrawOval s.slider_x,s.y,15,15
			
			If mouseinrect(s.slider_x,s.y,15,15) Then
				mousestate = 2
				
				If MouseHit(1) Then
					s.dragging = Not s.dragging
				EndIf
			EndIf
			
			If s.dragging Then
				s.slider_x = MouseX()-7
			EndIf
			
			If s.slider_x > s.x+s.width-15 Then s.slider_x = s.x+s.width-15
			If s.slider_x < s.x Then s.slider_x = s.x
		EndIf
	Next
	
	
	If red_slider.dragging Then
		selected_r = red_slider.slider_x-red_slider.x
	EndIf
	
	If green_slider.dragging Then
		selected_g = green_slider.slider_x-green_slider.x
	EndIf

	If blue_slider.dragging Then
		selected_b = blue_slider.slider_x-blue_slider.x
	EndIf

EndFunction

Function character_editor()
	Local winX = editor_window.x+editor_window.width/2
	Local winY = editor_window.y+editor_window.height/2
	
	
	SetScale 5,5
	SetColor selected_r,selected_g,selected_b
	DrawImage char_img,winX,winY

	SetColor 255,255,255

	Select smile_selected
		Case 0
			DrawImage smile0_img,winX,winY
		Case 1
			DrawImage smile1_img,winX,winY		
		Case 2
			DrawImage smile2_img,winX,winY	
		Case 3
			DrawImage smile3_img,winX,winY
		Case 4
			DrawImage smile4_img,winX,winY	
	EndSelect

	Select eyes_selected
		Case 0
			DrawImage eyes0_img,winX,winY
		Case 1
			DrawImage eyes1_img,winX,winY		
		Case 2
			DrawImage eyes2_img,winX,winY	
		Case 3
			DrawImage eyes3_img,winX,winY
		Case 4
			DrawImage eyes4_img,winX,winY
	EndSelect
	
	
	SetScale 1,1
EndFunction

Function handlewindows()
	SetScale 1,1
	For win:window = EachIn window_list
		If win.visible Then 
			DrawRect2 win.x,win.y,win.width,win.height,3, 128,128,128
			
			SetImageFont font2
			SetColor 180,180,180
			DrawText win.title,win.x+win.width/2-TextWidth(win.title)/2,win.y+3
			SetImageFont font			
		EndIf
	Next
	SetColor 255,255,255
EndFunction

Function DrawRect2(x1,y1,w1,h1,thickness = 2,red = 255, green = 255, blue = 255)
	SetColor red,green,blue
	DrawRect x1,y1,w1,h1
	
	SetColor 255,255,255
	DrawRect x1,y1,thickness,h1
	DrawRect x1,y1,w1,thickness
	DrawRect x1,y1+h1-thickness,w1,thickness
	DrawRect x1+w1-thickness,y1,thickness,h1
EndFunction


Function handle_menu_buttons()
	SetScale 1,1
	For b:button = EachIn button_list
		If b.active Then
			If mouseinrect(b.x,b.y,b.width,b.height) Then
				drawrect2 b.x,b.y,b.width,b.height,3,110,110,110
	
				mousestate = 2
				
				If MouseDown(1) Then
					b.clicked = True
					FlushMouse()
				EndIf
			Else
				drawrect2 b.x,b.y,b.width,b.height,3,180,180,180
			EndIf

			SetColor 150,150,150
			DrawText b.t,b.x+8,b.y+2
		EndIf
	Next
	
	
	
	If playbutton.clicked = True Then
		playbutton.clicked = False
		menuExited = True
		
	EndIf

	If chareditor.clicked = True Then
		chareditor.clicked = False
		
		editor_window.visible = Not editor_window.visible
		option_window.visible = False
		server_window.visible = False
	EndIf

	If multiplayer.clicked = True Then
		multiplayer.clicked = False

		server_window.visible = Not server_window.visible
		option_window.visible = False
		editor_window.visible = False		
	EndIf
	
	If options.clicked = True Then
		options.clicked = False

		option_window.visible = Not option_window.visible
		server_window.visible = False
		editor_window.visible = False
	EndIf
	
	If exitbutton.clicked = True Then
		CloseGNetHost host

		End
		
	EndIf
	
	
	If left_smile.clicked = True Then
		left_smile.clicked = False
		
		smile_selected = smile_selected - 1
		
		If smile_selected < 0 Then smile_selected = smile_count 
		
	EndIf

	If right_smile.clicked = True Then
		right_smile.clicked = False
		
		smile_selected = smile_selected + 1
		
		If smile_selected > smile_count Then smile_selected = 0
		
	EndIf

	If left_eyes.clicked = True Then
		left_eyes.clicked = False
		
		eyes_selected = eyes_selected - 1
		
		If eyes_selected < 0 Then eyes_selected = eyes_count
		
	EndIf

	If right_eyes.clicked = True Then
		right_eyes.clicked = False
		
		eyes_selected = eyes_selected + 1
		
		If eyes_selected > eyes_count Then eyes_selected = 0
		
	EndIf
	
	If resume_game.clicked = True Then
		resume_game.clicked = False
		paused = False
	EndIf
	
	SetColor 255,255,255
EndFunction

Function MouseInRect(x1,y1,w1,h1)
	If MouseX() > x1 And MouseX() < x1+w1 Then
		If MouseY() > y1 And MouseY() < y1+h1 Then
			Return True
		EndIf
	EndIf
EndFunction