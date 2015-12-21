//
//  ViewController.swift
//  TicTacToe
//
//  Created by HarveyHu on 7/30/15.
//  Copyright (c) 2015 HarveyHu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChessboardDelegate, AIDelegate {
    @IBOutlet weak var position1: UIButton!
    @IBOutlet weak var position2: UIButton!
    @IBOutlet weak var position3: UIButton!
    @IBOutlet weak var position4: UIButton!
    @IBOutlet weak var position5: UIButton!
    @IBOutlet weak var position6: UIButton!
    @IBOutlet weak var position7: UIButton!
    @IBOutlet weak var position8: UIButton!
    @IBOutlet weak var position9: UIButton!
    let imageO = UIImage(named: "o")
    let imageX = UIImage(named: "x")
    let chessboard = Chessboard.sharedInstance
    let robot = AI.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        chessboard.chessboardDelegate = self
        robot.aiDelagate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func positionTapped(sender: UIButton) {
        print(sender.tag)
        //trigger point
        chessboard.chessShow(sender.tag - 1, status: Chessboard.Status.Nought)
        let queue = dispatch_queue_create("background", nil)
        dispatch_async(queue) { [weak self] () -> Void in
            let newChessboard = self?.chessboard.copy() as! Chessboard
            if let roboticChess = self?.robot.getNextChess(newChessboard) {
            
            self?.chessboard.chessShow(roboticChess.rawValue, status: Chessboard.Status.Cross)
            }
        }
        
        
    }
    
    private func _changeButtonImage(button: UIButton, status: Chessboard.Status) {
        
            switch status {
            case .Nought:
                button.setImage(imageO, forState: .Normal)
                break
            case .Cross:
                button.setImage(imageX, forState: .Normal)
                break
            default:
                button.setImage(nil, forState: .Normal)
                break
            }
        
    }
    
    private func changeButtonsUserInteractionEnable(isEnable: Bool) {
        position1.userInteractionEnabled = isEnable
        position2.userInteractionEnabled = isEnable
        position3.userInteractionEnabled = isEnable
        position4.userInteractionEnabled = isEnable
        position5.userInteractionEnabled = isEnable
        position6.userInteractionEnabled = isEnable
        position7.userInteractionEnabled = isEnable
        position8.userInteractionEnabled = isEnable
        position9.userInteractionEnabled = isEnable
    }

    //ChessboardDelegate
    func show(chessboard: Array<Chessboard.Status>) {
        
        for index in 0 ..< 9 {
            switch index {
            case 0:
                _changeButtonImage(position1, status: chessboard[index])
                break
            case 1:
                _changeButtonImage(position2, status: chessboard[index])
                break
            case 2:
                _changeButtonImage(position3, status: chessboard[index])
                break
            case 3:
                _changeButtonImage(position4, status: chessboard[index])
                break
            case 4:
                _changeButtonImage(position5, status: chessboard[index])
                break
            case 5:
                _changeButtonImage(position6, status: chessboard[index])
                break
            case 6:
                _changeButtonImage(position7, status: chessboard[index])
                break
            case 7:
                _changeButtonImage(position8, status: chessboard[index])
                break
            case 8:
                _changeButtonImage(position9, status: chessboard[index])
                break
            default:
                break
            }
        }
    }
    func onGameOver(winner: Chessboard.Status) {
        print("Game Over!", winner, "win")
        chessboard.newGame()
    }
    
    //AIDelegate
    func thinkingWillStart() {
        changeButtonsUserInteractionEnable(false)
    }
    
    func thinkingDidEnd() {
        changeButtonsUserInteractionEnable(true)
    }
}

