

Type TBoard
	Field squares:Int[,]
	
	Function Create:TBoard()
		Local board:TBoard = New TBoard
		board.squares= New Int[BOARD_SIZE, BOARD_SIZE]
		Return board
	EndFunction
	
	Method init()
		For Local y:Int = 0 To BOARD_SIZE -1
		For Local x:Int = 0 To BOARD_SIZE -1
			Self.squares[x,y] = 0
		Next
		Next

		Self.squares[3,0] = 3
		Self.squares[3,1] = 3
		Self.squares[3,2] = 2
		Self.squares[3,3] = 1
		Self.squares[3,4] = 2
		Self.squares[3,5] = 3
		Self.squares[3,6] = 3
		Self.squares[0,3] = 3
		Self.squares[1,3] = 3
		Self.squares[2,3] = 2
		Self.squares[4,3] = 2
		Self.squares[5,3] = 3
		Self.squares[6,3] = 3
	EndMethod
EndType
