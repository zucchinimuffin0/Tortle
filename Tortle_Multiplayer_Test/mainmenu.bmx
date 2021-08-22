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

Global button_list:TList = New TList


Global playbutton:button = New button
playbutton.x = 10
playbutton.y = 200
playbutton.t = "Singleplayer"
playbutton.width = TextWidth(playbutton.t)+30
playbutton.height = TextHeight(playbutton.t)+4
playbutton.active = True

button_list.addlast(playbutton)

Global exitbutton:button = New button
exitbutton.x = 10
exitbutton.y = 230
exitbutton.t = "Exit"
exitbutton.width = TextWidth(playbutton.t)+30
exitbutton.height = TextHeight(playbutton.t)+4
exitbutton.active = True

button_list.addlast(exitbutton)

SetClsColor 135,206,250

While Not menuExited
	Cls
	
	
	SetColor 255,255,255
	DrawImage tester_img,w/2,h/2

	SetScale titlescale,titlescale
	DrawImage title_img,titlescale*ImageWidth(title_img)/2,titlescale*ImageHeight(title_img)/2
	SetScale 1,1
	
	
	
	
	If KeyHit(KEY_ESCAPE) Then
		menuExited = True
		FlushKeys()
	EndIf
	
	
	handle_menu_buttons
	
	If MouseHit(1) Then FlushMouse()
	
	Flip
Wend

Function handle_menu_buttons()
	For b:button = EachIn button_list
		
		If mouseinrect(b.x,b.y-ImageHeight(button_img)/2,ImageWidth(button_img),ImageHeight(button_img)) And b.active = True Then
			SetColor 128,128,128
		
			If MouseHit(1) Then
				b.clicked = True
			EndIf
		Else
			SetColor 255,255,255		
		EndIf
				
		DrawImage button_img,b.x+ImageWidth(button_img)/2,b.y
		
		SetColor 150,150,150
		DrawText b.t,b.x+8,b.y+2-ImageHeight(button_img)/2
	Next
	
	
	If playbutton.clicked = True Then
		playbutton.clicked = False
		menuExited = True
	EndIf
	
	If exitbutton.clicked = True Then
		End
	EndIf
EndFunction

Function MouseInRect(x1,y1,w1,h1)
	If MouseX() > x1 And MouseX() < x1+w1 Then
		If MouseY() > y1 And MouseY() < y1+h1 Then
			Return True
		EndIf
	EndIf
EndFunction