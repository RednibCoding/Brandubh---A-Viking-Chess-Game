Type TSquare
	Field x:Int
	Field y:Int
	
	Function Create:TSquare(x:Int, y:Int)
		Local square:TSquare = New TSquare
		square.x = x
		square.y = y
		Return square
	EndFunction
EndType

Type TGameController
	Global currentTurn:Int = BLACK
	Global clickedSquare:TSquare = Null
	Global legalMoves:TList
	Global startSquare:TSquare
	Global destSquare:TSquare


	Function _getLegalMoves:TList(board:Int[,], clickedX:Int, clickedY:Int)
		If clickedX < 0 Or clickedX > BOARD_SIZE-1 Return Null
		If clickedY < 0 Or clickedY > BOARD_SIZE-1 Return Null
		
		Local piece:Int = board[clickedX, clickedY]
		
		If piece = currentTurn Or (currentTurn = white And piece = king)
			Local moves:TList = New TList

			' calculate rows
			If Not (clickedY >= BOARD_SIZE -1)
				For Local y:Int = clickedY+1 To BOARD_SIZE -1
					If board[clickedX, y] = 0
						' Don't consider corner tiles or center square as movable
						If _isCornerSquare(clickedX, y) Or _isCentralSquare(clickedX, y)
							' KING can move there though
							If piece = KING moves.AddLast(TSquare.Create(clickedX, y))
						Else
							moves.AddLast(TSquare.Create(clickedX, y))
						EndIf
					Else
						Exit
					EndIf
				Next
			EndIf
			If Not (clickedY <= 0)
				For Local y:Int = clickedY-1 To 0 Step -1
					If board[clickedX, y] = 0
						' Don't consider corner tiles or center square as movable
						If _isCornerSquare(clickedX, y) Or _isCentralSquare(clickedX, y)
							' KING can move there though
							If piece = KING moves.AddLast(TSquare.Create(clickedX, y))
						Else
							moves.AddLast(TSquare.Create(clickedX, y))
						EndIf
					Else
						Exit
					EndIf
				Next
			EndIf

			' calculate columns
			If Not (clickedX >= BOARD_SIZE -1)
				For Local x:Int = clickedX+1 To BOARD_SIZE -1
					If board[x, clickedY] = 0
						' Don't consider corner tiles or center square as movable
						If _isCornerSquare(x, clickedY) Or _isCentralSquare(x, clickedY)
							' KING can move there though
							If piece = KING moves.AddLast(TSquare.Create(x, clickedY))
						Else
							moves.AddLast(TSquare.Create(x, clickedY))
						EndIf


					Else
						Exit
					EndIf
				Next
			EndIf
			If Not (clickedX <= 0)
				For Local x:Int = clickedX-1 To 0 Step -1
					If board[x, clickedY] = 0
						' Don't consider corner tiles or center square as movable
						If _isCornerSquare(x, clickedY) Or _isCentralSquare(x, clickedY)
							' KING can move there though
							If piece = KING moves.AddLast(TSquare.Create(x, clickedY))
						Else
							moves.AddLast(TSquare.Create(x, clickedY))
						EndIf
					Else
						Exit
					EndIf
				Next
			EndIf
			If moves.isEmpty() Return Null
			Return moves
		EndIf
		Return Null
	EndFunction
	
	Function _updateClickedSquare()
		If MouseHit(1)
			clickedSquare = New TSquare
			clickedSquare.x = (MouseX()-BOARDX)/SQUARE_SIZE
			clickedSquare.y = (MouseY()-BOARDY)/SQUARE_SIZE
		EndIf
		' Reset clicked square
		If MouseHit(2)
			clickedSquare = Null
		EndIf
	EndFunction
	
	Function _getClickedSquare:TSquare()
		If clickedSquare = Null Return Null
		Local squ:TSquare = New TSquare
		squ.x = clickedSquare.x
		squ.y = clickedSquare.y
		clickedSquare = Null
		Return squ
	EndFunction
	
	Function _checkForCapture:TList(squares:Int[,], destSquare:TSquare)
		Local capturedPieces:TList = New TList
		If currentTurn = BLACK
			If destSquare.x -1 >= 0
				If squares[destSquare.x-1, destSquare.y] = WHITE Or squares[destSquare.x-1, destSquare.y] = KING
					If destSquare.x -2 >= 0
						If squares[destSquare.x-2, destSquare.y] = BLACK Or _isCornerSquare(destSquare.x-2, destSquare.y)
							Local square:TSquare = New TSquare
							square.x = destSquare.x-1
							square.y = destSquare.y
							capturedPieces.AddLast(square)
						EndIf
					EndIf		
				EndIf
			EndIf
			If destSquare.x +1 <= BOARD_SIZE-1
				If squares[destSquare.x+1, destSquare.y] = WHITE Or squares[destSquare.x+1, destSquare.y] = KING
					If destSquare.x -2 <= BOARD_SIZE-1
						If squares[destSquare.x+2, destSquare.y] = BLACK Or _isCornerSquare(destSquare.x+2, destSquare.y)
							Local square:TSquare = New TSquare
							square.x = destSquare.x+1
							square.y = destSquare.y
							capturedPieces.AddLast(square)
						EndIf
					EndIf
				EndIf
			EndIf
			If destSquare.y -1 >= 0
				If squares[destSquare.x, destSquare.y-1] = WHITE Or squares[destSquare.x, destSquare.y-1] = KING
					If destSquare.y -2 >= 0
						If squares[destSquare.x, destSquare.y-2] = BLACK Or _isCornerSquare(destSquare.x, destSquare.y-2)
							Local square:TSquare = New TSquare
							square.x = destSquare.x
							square.y = destSquare.y-1
							capturedPieces.AddLast(square)
						EndIf
					EndIf
				EndIf
			EndIf
			If destSquare.y +1 <= BOARD_SIZE-1
				If squares[destSquare.x, destSquare.y+1] = WHITE Or squares[destSquare.x, destSquare.y+1] = KING
					If destSquare.y -2 <= BOARD_SIZE-1
						If squares[destSquare.x, destSquare.y+2] = BLACK Or _isCornerSquare(destSquare.x, destSquare.y+2)
							Local square:TSquare = New TSquare
							square.x = destSquare.x
							square.y = destSquare.y+1
							capturedPieces.AddLast(square)
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If destSquare.x -1 >= 0
				If squares[destSquare.x-1, destSquare.y] = BLACK
					If destSquare.x -2 >= 0
						If squares[destSquare.x-2, destSquare.y] = WHITE Or squares[destSquare.x-2, destSquare.y] = KING Or _isCornerSquare(destSquare.x-2, destSquare.y)
							Local square:TSquare = New TSquare
							square.x = destSquare.x-1
							square.y = destSquare.y
							capturedPieces.AddLast(square)
						EndIf
					EndIf
				EndIf
			EndIf
			If destSquare.x +1 <= BOARD_SIZE-1
				If squares[destSquare.x+1, destSquare.y] = BLACK
					If destSquare.x -2 <= BOARD_SIZE-1
						If squares[destSquare.x+2, destSquare.y] = WHITE  Or squares[destSquare.x+2, destSquare.y] = KING Or _isCornerSquare(destSquare.x+2, destSquare.y)
							Local square:TSquare = New TSquare
							square.x = destSquare.x+1
							square.y = destSquare.y
							capturedPieces.AddLast(square)
						EndIf
					EndIf
				EndIf
			EndIf
			If destSquare.y -1 >= 0
				If squares[destSquare.x, destSquare.y-1] = BLACK
					If destSquare.y -2 >= 0
						If squares[destSquare.x, destSquare.y-2] = WHITE Or squares[destSquare.x, destSquare.y-2] = KING Or _isCornerSquare(destSquare.x, destSquare.y-2)
							Local square:TSquare = New TSquare
							square.x = destSquare.x
							square.y = destSquare.y-1
							capturedPieces.AddLast(square)
						EndIf
					EndIf
				EndIf
			EndIf
			If destSquare.y +1 <= BOARD_SIZE-1
				If squares[destSquare.x, destSquare.y+1] = BLACK
					If destSquare.y +2 <= BOARD_SIZE-1
						If squares[destSquare.x, destSquare.y+2] = WHITE Or squares[destSquare.x, destSquare.y+2] = KING Or _isCornerSquare(destSquare.x, destSquare.y+2)
							Local square:TSquare = New TSquare
							square.x = destSquare.x
							square.y = destSquare.y+1
							capturedPieces.AddLast(square)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		If capturedPieces.IsEmpty() Return Null
		Return capturedPieces
	EndFunction
		
	Function _removeCapturedPiece(squares:Int[,], square:TSquare)
		If square.x >= 0 And square.x <= BOARD_SIZE-1
		If square.y >= 0 And square.y <= BOARD_SIZE-1
			squares:Int[square.x, square.y] = 0
			PlaySound(sndPieceDie)
		EndIf
		EndIf
	EndFunction
	
	Function _movePiece(squares:Int[,], startSqu:TSquare, destSqu:TSquare)
		Local start:Int = squares[startSqu.x, startSqu.y]
		If start = currentTurn Or (currentTurn = White And start = KING)
			squares[destSqu.x, destSqu.y] = start
			squares[startSqu.x, startSqu.y] = 0
			PlaySound(sndMove)
		EndIf
	EndFunction
	
	Function _updateTurn()
		If currentTurn = WHITE
			currentTurn = BLACK
		Else
			currentTurn = WHITE
		EndIf
	EndFunction
	
	Function _isCornerSquare:Int(x:Int, y:Int)
		If x = 0 And y = 0 Return True
		If x = 0 And y = BOARD_SIZE-1 Return True
		If x = BOARD_SIZE-1 And y = 0 Return True
		If x = BOARD_SIZE-1 And y = BOARD_SIZE-1 Return True
		Return False
	EndFunction
	
	Function _isCentralSquare:Int(x:Int, y:Int)
		If x = 3 And y = 3 Return True
		Return False
	End Function

	
	' Returns either 0 for no win yet, BLACK or WHITE
	Function checkWin:Int(squares:Int[,])
		Local win:Int = BLACK
		' Check if king is still on the board
		For Local y:Int = 0 To BOARD_SIZE-1
		For Local x:Int = 0 To BOARD_SIZE-1
			If squares[x, y] = KING win = 0
		Next
		Next
		
		' Check if king is on one of the corner squares
		If squares[0, 0] = KING Or squares[BOARD_SIZE-1, 0] = KING Or squares[0, BOARD_SIZE-1] Or squares[BOARD_SIZE-1, BOARD_SIZE-1] = KING
			win = WHITE
		EndIf
		
		Return win
	EndFunction
	
	Function newGame(board:TBoard)
		currentTurn = BLACK
		clickedSquare = Null
		legalMoves = Null	
		startSquare = Null
		destSquare = Null
		board.init()
	EndFunction
	
	Function checkAndPerformMoves(board:TBoard)
		_updateClickedSquare()
		Local clickedSquare:TSquare = _getClickedSquare()
		If clickedSquare <> Null
			legalMoves = _getLegalMoves(board.squares, clickedSquare.x, clickedSquare.y)
		EndIf
		
		If startSquare = Null And clickedSquare <> Null
			If board.squares[clickedSquare.x, clickedSquare.y] = currentTurn Or (currentTurn = White And board.squares[clickedSquare.x, clickedSquare.y] = KING)
				startSquare = clickedSquare
			EndIf
		ElseIf destSquare = Null And clickedSquare <> Null
			legalMoves = _getLegalMoves(board.squares, startSquare.x, startSquare.y)
			If legalMoves <> Null
				For Local legMove:TSquare = EachIn legalMoves
					If legMove.x = clickedSquare.x And legMove.y = clickedSquare.y
						destSquare = clickedSquare
						legalMoves = Null
						Exit
					EndIf
				Next
				If destSquare = Null
					startSquare = Null
					legalMoves = Null
				EndIf
			EndIf
		EndIf
		
		If startSquare <> Null And destSquare <> Null
			_movePiece(board.squares, startSquare, destSquare)
			Local capturedPieces:TList = _checkForCapture(board.squares, destSquare)
			If capturedPieces <> Null
				For Local capPiece:TSquare = EachIn capturedPieces
					_removeCapturedPiece(board.squares, capPiece)
				Next
			EndIf
			startSquare = Null
			destSquare = Null
			_updateTurn()
		EndIf
	EndFunction

EndType









