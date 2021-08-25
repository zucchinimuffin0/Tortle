Import BRL.GNet
Import BRL.BASIC

Global w = 800
Global h = 600

AppTitle = "Tortle 1.0"

Graphics w,h,0

''player variables
Global xoffset:Float = 0.0
Global yoffset:Float = 0.0

Global xvel:Float = 0.0
Global yvel:Float = 0.0

Global accel:Float = 0.2
Global friction:Float = 0.91

Global plr_angle:Float = 0
Global angular_v:Float = 0.0

Global plr_eyes = 0
Global plr_mouth = 0

Global plr_name:String = ""

Global canmove = True

Global frame:Float = 0
Global dir = 0

Global mouselocked = True

Global zoom:Float = 2

Global mouseshown = True

Global plr_R = 255
Global plr_G = 255
Global plr_B = 255

Global paused = False

''------
Global GAMEPORT=31415

Const SLOT_TYPE=0
Const SLOT_NAME=1
Const SLOT_CHAT=2		
Const SLOT_X=3
Const SLOT_Y=4
Const SLOT_VX=5
Const SLOT_VY=6
Const SLOT_ROT=7
Const SLOT_AV = 8
Const SLOT_R = 9
Const SLOT_G = 10
Const SLOT_B = 11
Const SLOT_MAP = 12
Const SLOT_EYES = 13
Const SLOT_MOUTH = 14

Global host:TGNetHost=CreateGNetHost()

Global localPlayer:TGNetObject=CreateGNetObject(host)


Include "console.bmx"

init()

Include "loadfiles.bmx"

Include "mainmenu.bmx"

plr_name = name_selected
plr_r = selected_r
plr_g = selected_g
plr_b = selected_b
plr_eyes = eyes_selected
plr_mouth = smile_selected

SetGNetString localPlayer,SLOT_NAME,plr_name
SetGNetString localPlayer,SLOT_CHAT,""

SetGNetFloat localPlayer,SLOT_X,xoffset
SetGNetFloat localPlayer,SLOT_Y,yoffset
SetGNetFloat localPlayer,SLOT_ROT,plr_angle

SetGNetInt localPlayer,SLOT_R,plr_r
SetGNetInt localPlayer,SLOT_G,plr_g
SetGNetInt localPlayer,SLOT_B,plr_b

SetGNetInt localPlayer,SLOT_EYES,plr_eyes
SetGNetInt localPlayer,SLOT_MOUTH,plr_mouth


Global mapsizex = 32
Global mapsizey = 32

Global curmap:Int[,] = loadmap("assets\maps\lvl_1.lvl")
Global curstuff:Int[,] = loadmap("assets\maps\lvl_1.stf")

Global waterframe:Float = 0

For x = 0 To mapsizex-1
	For y = 0 To mapsizey-1
		If curmap[x,y] = 9 Then
			xoffset = -x*32+w/2
			yoffset = -y*32+h/2
			create_console_msg("Spawned player","command")
		EndIf
	Next
Next


''Global curmap[mapsizex,mapsizey]
SetImageFont font2

Repeat
	Cls
	
	mousestate = 0
	canmove = True
	
	drawCurrentMap()
	
	If KeyHit(KEY_TILDE) Then 
		FlushKeys()
		consoleopen = Not consoleopen
	EndIf

	player_draw()

		
	If consoleopen Then
		chat()

		console()
		drawconsole()
	EndIf
	

	GNetSync host

	
	If KeyHit(KEY_ESCAPE) Then paused = Not paused
	
	If paused Then
		canmove = False
		SetImageFont font
		resume_game.active = True
		multiplayer.active = True
		exitbutton.active = True
		options.active = True
		chareditor.active = True
	
	
		handlewindows()
		handle_menu_buttons()
	
		If editor_window.visible Then 
			character_editor()
			left_smile.active = True		
			right_smile.active = True
			left_eyes.active = True		
			right_eyes.active = True
			
			plr_eyes = eyes_selected
			plr_mouth = smile_selected
			
			SetGNetInt localPlayer,SLOT_EYES,plr_eyes
			SetGNetInt localPlayer,SLOT_MOUTH,plr_mouth
			
		Else
			left_smile.active = False
			right_smile.active = False
			left_eyes.active = False		
			right_eyes.active = False
		EndIf
		SetImageFont Null
	Else
		resume_game.active = False
		multiplayer.active = False
		exitbutton.active = False
		options.active = False
		chareditor.active = False


		left_smile.active = False
		right_smile.active = False
		left_eyes.active = False		
		right_eyes.active = False

		
		editor_window.visible = False
		server_window.visible = False
		option_window.visible = False
	EndIf
	
	player_control()
	
	If MouseHit(1) Then FlushMouse()
	
	SetScale 1,1
	Select mousestate
		Case 0
			DrawImage cursor1_img,MouseX(),MouseY()
		Case 1
			DrawImage cursor2_img,MouseX(),MouseY()
		Case 2
			DrawImage cursor3_img,MouseX(),MouseY()
	EndSelect
	
	SetScale zoom,zoom
	Flip
Forever

CloseGNetHost host

End

Function Chat()
	For Local obj:TGNetObject=EachIn GNetObjects(host)
		If obj.State()=GNET_CLOSED Continue
					
		Local text:String = GetGNetString(obj,SLOT_CHAT)
	
		Local r:Int = GetGNetInt(obj,SLOT_R)
		Local g:Int = GetGNetInt(obj,SLOT_G)
		Local b:Int = GetGNetInt(obj,SLOT_B)
		
		create_console_msg(text,"",True,r,g,b)
		
		SetGNetString(obj,SLOT_CHAT,"")
	Next
	SetColor 255,255,255

EndFunction


Function init()
	create_console_msg("BEGIN LOG")
EndFunction

Function findchar:String(strin:String,count)
	Return(Right(Left(strin,count),1))
EndFunction

Function player_draw()
	For Local obj:TGNetObject=EachIn GNetObjects(host)
		If obj.State()=GNET_CLOSED Continue

		Local xp#=GetGNetFloat(obj,SLOT_X)
		Local yp#=GetGNetFloat(obj,SLOT_Y)
		Local rot#=GetGNetFloat(obj,SLOT_ROT)
		Local name:String = GetGNetString(obj,SLOT_NAME)
		Local r:Int = GetGNetInt(obj,SLOT_R)
		Local g:Int = GetGNetInt(obj,SLOT_G)
		Local b:Int = GetGNetInt(obj,SLOT_B)
		Local eye:Int = GetGNetInt(obj,SLOT_EYES)
		Local mouth:Int = GetGNetInt(obj,SLOT_MOUTH)
	
		
		SetRotation rot
		
		Local plrX:Float = (xoffset-xp)*zoom+w/2
		Local plrY:Float = (yoffset-yp)*zoom+h/2

		SetColor r,g,b
		DrawImage char_img,plrX,plrY
		SetColor 255,255,255
		
		
		Select eye
			Case 0
				DrawImage eyes0_img,plrX,plrY
			Case 1
				DrawImage eyes1_img,plrX,plrY
			Case 2
				DrawImage eyes2_img,plrX,plrY
			Case 3
				DrawImage eyes3_img,plrX,plrY
		EndSelect
		
		Select mouth
			Case 0
				DrawImage smile0_img,plrX,plrY
			Case 1
				DrawImage smile1_img,plrX,plrY
			Case 2
				DrawImage smile2_img,plrX,plrY
			Case 3
				DrawImage smile3_img,plrX,plrY
		EndSelect
		
		
		SetColor r,g,b
		
		SetRotation 0
		SetImageFont Null
		DrawText name,plrX-(TextWidth(name)*zoom)/2,plrY-(TextHeight(name)*zoom*2)
		
		
	Next
	SetColor 255,255,255
EndFunction

Function Dist:Float(x1:Float,y1:Float,x2:Float,y2:Float)
	Return( Sqr( (x1*x2)-(y1*y2) ) )
EndFunction

Function player_control()
	If canmove Then
		If KeyDown(KEY_O) And zoom > 1/1.25 Then
			zoom = zoom * 0.99
		EndIf
		
		If KeyDown(KEY_I) And zoom < 4.5 Then
			zoom = zoom / 0.99
		EndIf
		
		If mouselocked Then
			If KeyDown(KEY_A) Then
				angular_v = angular_v - accel
			EndIf
			If KeyDown(KEY_D) Then
				angular_v = angular_v + accel
			EndIf			
		Else
			mousestate = 1
			angular_v = 0
			plr_angle = ATan2(h/2-MouseY(),w/2-MouseX())
		EndIf
		
		
		If KeyDown(KEY_W) Then
			yvel = yvel + accel*Sin(plr_angle)
			xvel = xvel + accel*Cos(plr_angle)
			
		EndIf
		If KeyDown(KEY_S) Then
			yvel = yvel - accel*Sin(plr_angle)
			xvel = xvel - accel*Cos(plr_angle)			
		EndIf
		
		
		If Not KeyDown(KEY_W) And Not KeyDown(KEY_A) And Not KeyDown(KEY_S) And Not KeyDown(KEY_D) Then
			frame = 0
		EndIf
		
		If KeyHit(KEY_SPACE) Then
			mouselocked = Not mouselocked
			mouseshown = Not mouseshown
		EndIf
	EndIf
	
	xoffset = xoffset + xvel
	yoffset = yoffset + yvel

	plr_angle = plr_angle + angular_v
	
	xvel = xvel * friction
	yvel = yvel * friction
	
	angular_v = angular_v * friction

	''SetGNetFloat localPlayer,SLOT_VX,xvel
	''SetGNetFloat localPlayer,SLOT_VY,yvel
	
	SetGNetFloat localPlayer,SLOT_X,xoffset
	SetGNetFloat localPlayer,SLOT_Y,yoffset
	
	''SetGNetFloat localPlayer,SLOT_AV,angular_v
	SetGNetFloat localPlayer,SLOT_ROT,plr_angle

	''Select dir
	''	Case 0
	''		If frame >= 4 Then frame = 0
	''	Default
	''		If frame > 8 Then frame = 4
	''		If frame <= 4 Then frame = 4
	''EndSelect
EndFunction

Function drawCurrentMap()
	waterframe = waterframe + 0.01
	If waterframe > 3 Then waterframe = 0
		
	For x = 0 To mapsizex-1
		For y = 0 To mapsizey-1
			
			Local xpos:Float = (x*32+xoffset-w/2)*zoom+w/2
			Local ypos:Float = (y*32+yoffset-h/2)*zoom+h/2
			
			If xpos < w+16*zoom And xpos > -16*zoom And ypos < h+16*zoom And ypos > -16*zoom Then
				Select curmap[x,y]
					Case 0
						DrawImage grass_img,xpos,ypos
					Case 1
						DrawImage dirt_img,xpos,ypos
					Case 2
						DrawImage water_img,xpos,ypos,waterframe
					Case 3
						DrawImage water_img,xpos,ypos,waterframe
						DrawImage grass_cc_img,xpos,ypos
					Case 4
						DrawImage water_img,xpos,ypos,waterframe
						SetRotation -90
						DrawImage grass_cc_img,xpos,ypos
						SetRotation 0
					Case 5
						DrawImage water_img,xpos,ypos,waterframe
						SetRotation 180
						DrawImage grass_cc_img,xpos,ypos
						SetRotation 0
					Case 6
						DrawImage water_img,xpos,ypos,waterframe
						SetRotation 90
						DrawImage grass_cc_img,xpos,ypos
						SetRotation 0
	
					Case 7
						DrawImage sand_img,xpos,ypos
					Case 8
						DrawImage path_img,xpos,ypos
	
					Case 9
						DrawImage grass_img,xpos,ypos
						DrawImage spawn_img,xpos,ypos
					Default
						DrawImage unknown_img,xpos,ypos
				EndSelect
								
				Select curstuff[x,y]
					Case 0
					Case 1
						DrawImage bush_img,xpos,ypos
					Case 2
						DrawImage tree_trunk_img,xpos,ypos
					Case 3
						DrawImage tree_trunk_top_img,xpos,ypos				
					Default
						DrawImage unknown_img,xpos,ypos
				EndSelect
			EndIf	
		Next
	Next
EndFunction