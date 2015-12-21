//
//  AI.swift
//  TicTacToe
//
//  Created by HarveyHu on 7/30/15.
//  Copyright (c) 2015 HarveyHu. All rights reserved.
//

import Foundation

protocol AIDelegate {
    func thinkingWillStart()
    func thinkingDidEnd()
}

class AI {
    static let sharedInstance = AI()
    enum Chess: Int {
        case TopLeft = 0
        case Top = 1
        case TopRight = 2
        case Left = 3
        case Center = 4
        case Right = 5
        case BottomLeft = 6
        case Bottom = 7
        case BottomRight = 8
        case NoMove = 9
    }
    var aiDelagate: AIDelegate?
    
    func getNextChess(chessboard: Chessboard) -> Chess {
        aiDelagate?.thinkingWillStart()
        let result = minMax(chessboard, gameRound: 0)
        aiDelagate?.thinkingDidEnd()
        return result.chess
    }
    
    private func minMax(chessboard: Chessboard, gameRound:Int) -> (chess: Chess, score: Int) {
        
        //judge conclusion
        if chessboard.checkGameOver() {
            let result = (Chess.NoMove, calculateScore(chessboard, gameRound: gameRound))
            return result
        }
        
        //calculate highest score
        var bestScore = 0
        var bestMove = Chess.NoMove
        
        let turn = gameRound % 2
        
        if turn == 0 {
            bestScore = -LONG_MAX;
        }
        else{
            bestScore = +LONG_MAX;
        }
        
        if let legalMoves = chessboard.generateLegalMoves() {
            for move in legalMoves {
                let newChessboard = chessboard.copy() as! Chessboard
                newChessboard.chess(move, status: turn == 0 ? Chessboard.Status.Cross: Chessboard.Status.Nought)
                
                let result = self.minMax(newChessboard, gameRound: gameRound + 1)
                let score = result.score
                let newMove = move
                
                if turn == 0 {
                    if score > bestScore {
                        bestScore = score
                        bestMove = Chess.init(rawValue: newMove)!
                    }
                }
                else
                {
                    if(score < bestScore){
                        bestScore = score
                        bestMove = Chess.init(rawValue: newMove)!
                    }
                }
            }
        }
        return (bestMove, bestScore)
    }
    
    private func calculateScore(chessboard: Chessboard, gameRound: Int) -> Int {
        if chessboard.checkWin() == Chessboard.Status.Nought {
            return -10 + gameRound
        } else if chessboard.checkWin() == Chessboard.Status.Cross {
            return 10 - gameRound
        }
        return 0
    }
    
}