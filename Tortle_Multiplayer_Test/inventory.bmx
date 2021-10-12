Global inventory_selected = 0

Global inventory:Int[7]
Global inventory_id:Int[7]


Type item
Field x:Float
Field y:Float
Field id
Field img:TImage
EndType

Global item_list:TList = New TList

Global fruit:item = New item
fruit.x = 10
fruit.y = 10
fruit.id = 1
fruit.img = fruit_img

item_list.addlast(fruit)


Function draw_item()
	For i:item = EachIn item_list

		Local xpos:Float = (i.x*32+xoffset-w/2)*zoom+w/2
		Local ypos:Float = (i.y*32+yoffset-h/2)*zoom+h/2
				
		''DrawText dist(i.x,i.y,w/2,h/2),200,200		
		''DrawImage i.img,xpos,ypos
		
		If dist(i.x,i.y,w/2,h/2) < 1 Then
			
			If MouseDown(1) Then
						item_list.remove(i)

			EndIf
			
		EndIf
		
		
	Next
EndFunction

Function DrawRect3(x,y,width,height,thickness = 4)
	DrawRect x,y,thickness,height
	DrawRect x,y,width,thickness
	DrawRect x,y+height-thickness,width,thickness
	DrawRect x+width-thickness,y,thickness,height
EndFunction

Function draw_gui_elements()
	SetScale 2,2
	SetColor 255,255,255
	
	DrawImage inventory_img,2,2
	
	SetScale 1,1
	SetColor 0,0,0
	DrawRect3 32*2*inventory_selected-2*inventory_selected+2,2,32*2,32*2
	
	SetColor 255,255,255
EndFunction
