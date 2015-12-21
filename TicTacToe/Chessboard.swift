//
//  Chessboard.swift
//  TicTacToe
//
//  Created by HarveyHu on 7/30/15.
//  Copyright (c) 2015 HarveyHu. All rights reserved.
//

import Foundation

protocol ChessboardDelegate {
    func show(chessboard: Array<Chessboard.Status>)
    func onGameOver(winner: Chessboard.Status)
}

class Chessboard: NSCopying {
    static let sharedInstance = Chessboard()
    enum Status: Int {
        case Empty = 0
        case Nought = 1
        case Cross = 2
    }
    var chessboardDelegate: ChessboardDelegate?
    var firstHand: Status = Status.Nought
    
    private var _currentBoard = Array<Status>(count: 9, repeatedValue: Status.Empty)
    private let _lineSets: Set<Set<Int>> = [[0, 4, 8], [2, 4, 6], [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8]]
    
    
    func copy() -> AnyObject! {
        if let asCopying = ((self as AnyObject) as? NSCopying) {
            return asCopying.copyWithZone(nil)
        }
        else {
            assert(false, "This class doesn't implement NSCopying")
            return nil
        }
    }
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        let newValue = Chessboard()
        newValue._currentBoard = _currentBoard
        newValue.firstHand = firstHand
        return newValue
    }
    
    func chess(position: Int, status: Status, isShow: Bool = false) -> Bool {
        if position < 9 && _currentBoard[position] == Status.Empty {
            _currentBoard[position] = status
            if isShow {
                dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
                    if let strongSelf = self {
                        strongSelf.chessboardDelegate?.show(strongSelf._currentBoard)
                        if strongSelf.checkGameOver() {
                            strongSelf.chessboardDelegate?.onGameOver(strongSelf.checkWin())
                        }
                    }
                }
            }
            return true
        }
        return false
    }
    
    func chessShow(position: Int, status: Status) -> Bool {
        return chess(position, status: status, isShow: true)
    }
    
    func generateLegalMoves() -> [Int]? {
        var legalMoves = Array<Int>()
        for position in 0 ..< 9 {
            if _currentBoard[position] == Status.Empty {
                legalMoves.append(position)
            }
        }
        if legalMoves.count > 0 {
            return legalMoves
        }
        return nil
    }
    
    func newGame() {
        _currentBoard.removeAll()
        _currentBoard = Array<Status>(count: 9, repeatedValue: Status.Empty)
        chessboardDelegate?.show(_currentBoard)
    }
    
    func checkWin() -> Status {
        var noughtSet = Set<Int>()
        var crossSet = Set<Int>()
        for index in 0 ..< _currentBoard.count {
            switch _currentBoard[index] {
            case Status.Nought:
                noughtSet.insert(index)
                break
            case Status.Cross:
                crossSet.insert(index)
                break
            default:
                break
            }
        }
        
        for lineSet in _lineSets {
            if lineSet.isSubsetOf(noughtSet) {
                return Status.Nought
            } else if lineSet.isSubsetOf(crossSet) {
                return Status.Cross
            }
        }
        //not end yet
        return Status.Empty
    }
    
    func checkGameOver() -> Bool {
        var isFull = true
        for index in 0 ..< _currentBoard.count {
            if _currentBoard[index] == Status.Empty {
                isFull = false
                break
            }
        }
        if checkWin() == Status.Empty && !isFull {
            return false
        }
        return true
    }
}