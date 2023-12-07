//
//  TicTacToeViewController.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 27/11/2023.
//

import UIKit

class TicTacToeViewController: UIViewController {

    enum Turn: String {
        case TurnX = "X"
        case TurnO = "O"
    }

    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    @IBOutlet weak var b9: UIButton!
    @IBOutlet weak var b10: UIButton!
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b12: UIButton!
    @IBOutlet weak var b13: UIButton!
    @IBOutlet weak var b14: UIButton!
    @IBOutlet weak var b15: UIButton!
    @IBOutlet weak var b16: UIButton!
    
    
    var firstTurn = Turn.TurnO
    var currentTurn = Turn.TurnO
    
    var board = Array(repeating: Array(repeating: UIButton(), count: 4), count: 4)
    var usedButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        turnLabel.text = currentTurn.rawValue
    }

    func initBoard() {
        board[0][0] = b1
        board[0][1] = b2
        board[0][2] = b3
        board[0][3] = b4
        board[1][0] = b5
        board[1][1] = b6
        board[1][2] = b7
        board[1][3] = b8
        board[2][0] = b9
        board[2][1] = b10
        board[2][2] = b11
        board[2][3] = b12
        board[3][0] = b13
        board[3][1] = b14
        board[3][2] = b15
        board[3][3] = b16
        for i in board {
            for b in i {
                b.setTitle("", for: .normal)
            }
        }
    }
    
    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender: sender)
        
        if currentTurn == Turn.TurnX {
            if gameWon(turn: Turn.TurnO.rawValue) {
                resultAlert(title: "\(Turn.TurnO.rawValue) won!")
                updateStatistics(xWon: false)
            }
        } else {
            if gameWon(turn: Turn.TurnX.rawValue) {
                resultAlert(title: "\(Turn.TurnX.rawValue) won!")
                updateStatistics(xWon: true)
            }
        }
    }
    
    func updateStatistics(xWon: Bool) {
        var gamesFinished = UserDefaults.standard.value(forKey: "tictacGamesFinished") as? Int ?? 0
        gamesFinished += 1
        UserDefaults.standard.set(gamesFinished, forKey: "tictacGamesFinished")
        if xWon {
            let xVictories = UserDefaults.standard.value(forKey: "xVictories") as? Int ?? 0
            UserDefaults.standard.set(xVictories + 1, forKey: "xVictories")
        }
    }
    
    func resultAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Replay", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        for line in board {
            for button in line{
                button.setTitle("", for: .normal)
                button.isEnabled = true
            }
        }
        usedButtons.removeAll()
        if (firstTurn == Turn.TurnX) {
            firstTurn = Turn.TurnO
            turnLabel.text = Turn.TurnO.rawValue
        } else {
            firstTurn = Turn.TurnX
            turnLabel.text = Turn.TurnX.rawValue
        }
        currentTurn = firstTurn
    }
    
    func gameWon(turn: String) -> Bool{
        //check horizontally
        for line in board {
            var fullLine = true
            for button in line {
                if button.title(for: .normal) != turn {
                    fullLine = false
                    break
                }
            }
            if fullLine {
                return true
            }
        }
        //check vertically
        for i in 0..<board.count {
            var fullColumn = true
            for line in board {
                if line[i].title(for: .normal) != turn {
                    fullColumn = false
                    break
                }
            }
            if fullColumn {
                return true
            }
        }
        //check diagonally
        var fullDiagonal = true
        for i in 0..<board.count {
            if board[i][i].title(for: .normal) != turn {
                fullDiagonal = false
                break
            }
        }
        if fullDiagonal {
            return true
        }
        fullDiagonal = true
        for i in 0..<board.count {
            if board[i][board.count-1-i].title(for: .normal) != turn {
                fullDiagonal = false
                break
            }
        }
        if fullDiagonal {
            return true
        }
        return false
    }

    func addToBoard(sender: UIButton) {
        usedButtons.append(sender)
        if usedButtons.count > 10 {
            usedButtons[0].setTitle("", for: .normal)
            usedButtons[0].isEnabled = true
            usedButtons.removeFirst()
        }
        if (sender.title(for: .normal) == "") {
            if (currentTurn == Turn.TurnX) {
                sender.setTitle(Turn.TurnX.rawValue, for: .normal)
                currentTurn = Turn.TurnO
                turnLabel.text = Turn.TurnO.rawValue
            } else {
                sender.setTitle(Turn.TurnO.rawValue, for: .normal)
                currentTurn = Turn.TurnX
                turnLabel.text = Turn.TurnX.rawValue
            }
        }
        sender.isEnabled = false
    }
}
