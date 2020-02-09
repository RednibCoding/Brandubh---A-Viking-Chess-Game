SuperStrict

Framework BRL.GLMax2D
Import BRL.FreeAudioAudio
Import BRL.RamStream
Import BRL.PNGLoader
Import BRL.WAVLoader

AppTitle = "Brandubh  by Michael Binder"
Include "settings.bmx"
Include "assets.bmx"
Include "TBoard.bmx"
Include "TGameController.bmx"
Include "TGameView.bmx"


Graphics 544, 544
SetBlend(ALPHABLEND)



Local board:TBoard = TBoard.Create()
Local controller:TGameController = New TGameController
Local view:TGameView = New TGameView
board.init()

DrawImage(imgTitle, 0, 0)
Flip
Delay(1000)
WaitMouse()

Repeat
	If KeyDown(KEY_ESCAPE) Or AppTerminate() End

	controller.checkAndPerformMoves(board)
	
	Local win:Int = controller.checkWin(board.squares)
	If win <> 0
		Cls
		view.drawBoard(BOARDX, BOARDY)
		view.drawPieces(board.squares, BOARDX, BOARDY)
		view.highlightSquares(controller.legalMoves)
		If win = WHITE
			DrawImage(imgWhiteWins, BOARDX, BOARDY)
		ElseIf win = black
			DrawImage(imgBlackWins, BOARDX, BOARDY)
		EndIf
		
		PlaySound(sndWin)
		Flip
		Delay(3000)
		WaitMouse()
		controller.newGame(board)
	EndIf
	
	view.drawBoard(BOARDX, BOARDY)
	view.drawPieces(board.squares, BOARDX, BOARDY)
	view.highlightSquares(controller.legalMoves)

Flip;Cls;Forever;End



