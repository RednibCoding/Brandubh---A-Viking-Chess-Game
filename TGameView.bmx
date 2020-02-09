

Type TGameView
	Function drawPieces(squares:Int[,], offsetX:Int, offsetY:Int)
		For Local y:Int = 0 To BOARD_SIZE -1
		For Local x:Int = 0 To BOARD_SIZE -1
			If squares[x, y] = 1 DrawImage(imgWk, offsetX+(x*SQUARE_SIZE), offsetY+(y*SQUARE_SIZE))
			If squares[x, y] = 2 DrawImage(imgWp, offsetX+(x*SQUARE_SIZE), offsetY+(y*SQUARE_SIZE))
			If squares[x, y] = 3 DrawImage(imgBp, offsetX+(x*SQUARE_SIZE), offsetY+(y*SQUARE_SIZE))
		Next
		Next
	EndFunction

	Function drawBoard(offsetX:Int, offsetY:Int)
		DrawImage(imgBorder, offsetX-39, offsetY-38)
		DrawImage(imgBoard, offsetX, offsetY)
	EndFunction
	
	Function highlightSquares(squares:TList)
		If squares <> Null
			For Local squ:TSquare = EachIn squares
				Local x:Int = SQUARE_SIZE * squ.x + BOARDX
				Local y:Int = SQUARE_SIZE * squ.y + BOARDY
				DrawImage(imgHighlight, x, y)
			Next
		EndIf
	EndFunction
EndType
