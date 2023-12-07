//
//  ChessViewController.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 28/11/2023.
//

import UIKit

class ChessViewController: UIViewController, CustomAlertDelegate  {

    let turnLabel = UILabel()
    let mistakeText = UILabel()
    let mistakeNumber = UILabel()
    let mistakeStack = UIStackView()
    let nextButton = UIButton()
    var puzzles: [Puzzle] = []
    var colorToggle = true
    var colorIteration = 0
    let imageDictionary = ["P": "PawnW", "p": "PawnB",       "R": "RookW", "r": "RookB",
                           "N": "KnightW", "n": "KnightB",    "B": "BishopW", "b": "BishopB",
                           "Q": "QueenW", "q": "QueenB",     "K": "KingW", "k": "KingB"]
    var imageValues = [String](repeating: "", count: 64)
    let defaultPositions = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    var teamBlack = true
    var selectedCell: Int? = nil
    var movesDone = 0
    var moves: [[Int]] = []
    var computerMoves: (Int, Int)?
    var wrongMoves = 0
    var puzzleFinished = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBarView()
        nextButtonTapped(sender: nextButton)
    }
    
    func loadNewPuzzle() {
        let difficulty = UserDefaults.standard.value(forKey: "currentDifficulty") as? Float ?? 1000
        let headers = [
            "X-RapidAPI-Key": "7acda74e3fmshb712431a0e6cb83p121f6fjsnbff717cd61cb",
            "X-RapidAPI-Host": "chess-puzzles.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://chess-puzzles.p.rapidapi.com/?rating=\(Int(difficulty))&themesType=ALL&count=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let _: Void = session.dataTask(with: request as URLRequest) {
            data, response, error in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "")
            }
            guard let data = data else { return }

            do {
                let jsonData = try JSONDecoder().decode(ChessPuzzle.self, from: data)
                self.puzzles = jsonData.puzzles
                self.setChessPieces(position: self.puzzles.first?.fen ?? self.defaultPositions)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.makeNextMove(player: false)
                }
                print(self.puzzles[0].moves ?? "")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("error:", error)
            }
        }.resume()
    }
    
    private func setupNavigationBarView() {
        navigationController?.navigationBar.tintColor = UIColor.label
    }
    
    private func setupView() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        mistakeStack.translatesAutoresizingMaskIntoConstraints = false
        mistakeText.translatesAutoresizingMaskIntoConstraints = false
        mistakeNumber.translatesAutoresizingMaskIntoConstraints = false
        turnLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width - 8) / 8, height: (view.frame.size.width - 8) / 8)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        turnLabel.numberOfLines = 0
        turnLabel.textColor = .label
        turnLabel.textAlignment = .center
        turnLabel.text = "Make the best moves for \(teamBlack ? "black" : "white")"
        
        mistakeStack.backgroundColor = UIColor.systemBackground
        mistakeStack.axis = .horizontal
        
        mistakeText.textColor = .label
        mistakeText.textAlignment = .center
        mistakeText.text = "Mistakes made: \(wrongMoves)"
        
    
        nextButton.setTitle("Next puzzle", for: .normal)
        nextButton.setTitleColor(UIColor.label, for: .normal)
        nextButton.backgroundColor = UIColor.green
        nextButton.isHidden = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        mistakeStack.addSubview(mistakeText)
        mistakeStack.addSubview(mistakeNumber)
        view.addSubview(turnLabel)
        view.addSubview(mistakeStack)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.clipsToBounds = true
        
        view.bringSubviewToFront(nextButton)
        
        let screenHeight = view.frame.size.height
        NSLayoutConstraint.activate([
            turnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            turnLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight * 0.18),
            
            mistakeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mistakeStack.topAnchor.constraint(equalTo: turnLabel.bottomAnchor, constant: screenHeight * 0.01),
            mistakeStack.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            mistakeStack.heightAnchor.constraint(equalToConstant: 50),
            
            mistakeText.centerYAnchor.constraint(equalTo: mistakeStack.centerYAnchor),
            mistakeText.centerXAnchor.constraint(equalTo: mistakeStack.centerXAnchor, constant: -10),
            
            mistakeNumber.centerYAnchor.constraint(equalTo: mistakeStack.centerYAnchor),
            mistakeNumber.leadingAnchor.constraint(equalTo: mistakeText.trailingAnchor, constant: screenHeight * 0.01),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: mistakeStack.bottomAnchor, constant: screenHeight * 0.01   ),
            nextButton.widthAnchor.constraint(equalToConstant: 110),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            collectionView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: screenHeight * (0.06))
        ])
        
        collectionView.register(ChessCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.layer.borderWidth = 4
        if puzzles.isEmpty {
            setChessPieces(position: defaultPositions)
        }
    }
    
    @objc func nextButtonTapped(sender: UIButton!) {
        let chessAlert = ChessAlertViewController()
        chessAlert.delegate = self
        present(chessAlert, animated: true)
    }
    
    func updatePlayerColor(white: Bool) {
        if white {
            teamBlack = true
        } else {
            teamBlack = false
        }
    }
    
    func setChessPieces(position: String) {
        for (i, _) in imageValues.enumerated() {
            imageValues[i] = ""
        }
        var pos = position
        for boardRow in 0...7 {
            var column = 0
            while column < 8 {
                let char = String(pos.first!)
                pos = String(pos.dropFirst())
                if let num = Int(char) {
                    column += num
                } else {
                    if let imageName = imageDictionary[char] {
                        imageValues[boardRow * 8 + column] = imageName
                    } else {
                        fatalError("unknown chess piece" + char)
                    }
                    column += 1
                }
            }
            pos = String(pos.dropFirst())
        }
        updatePlayerColor(white: pos.first == "w")
        
    }
    
    func checkCorrectMove(position: Int) -> Bool {
        let move = convertMove(move: puzzles[0].moves![movesDone])
        if move.0 == selectedCell && move.1 == position {
            return true
        }
        return false
    }
    
    func convertMove(move: String) -> (Int, Int) {
        let letterToNumber = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7]
        let startColumn = Int(letterToNumber[String(move.first!)] ?? 0)
        let startRow = Int(String(move[move.index(move.startIndex, offsetBy: 1)]))
        let startPosition = (8 - startRow!) * 8 + (startColumn)
        
        let finishColumn = letterToNumber[String(move[move.index(move.startIndex, offsetBy: 2)])]
        let finishRow = Int(String(move.last!))
        let finishPosition = (8 - finishRow!) * 8 + (finishColumn!)
        return (startPosition, finishPosition)
    }
    
    func makeNextMove(player: Bool) {
        let move = convertMove(move: puzzles[0].moves![movesDone])
        print(move)
        let figure = imageValues[move.0]
        imageValues[move.0] = ""
        imageValues[move.1] = figure
        movesDone += 1
        if movesDone >= puzzles[0].moves?.count ?? 0 {
            endOfPuzzle()
        } else if player {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.makeNextMove(player: false)
            }
        } else {
            computerMoves = move
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func endOfPuzzle() {
        var gamesFinished = UserDefaults.standard.value(forKey: "chessGamesFinished") as? Int ?? 0
        var mistakeAverage = UserDefaults.standard.value(forKey: "chessMistakeAverage") as? Float ?? 0
        gamesFinished += 1
        mistakeAverage = (mistakeAverage * Float(gamesFinished - 1) + Float(wrongMoves)) / Float(gamesFinished)
        UserDefaults.standard.set(gamesFinished, forKey: "chessGamesFinished")
        UserDefaults.standard.set(mistakeAverage, forKey: "chessMistakeAverage")
        
        nextButton.isHidden = false
        movesDone = 0
        puzzleFinished = true
    }
    
    func FindButtonTapped() {
        wrongMoves = 0
        mistakeNumber.textColor = UIColor.label
        mistakeNumber.font = UIFont.systemFont(ofSize: 17)
        computerMoves = nil
        selectedCell = nil
        puzzleFinished = false
        loadNewPuzzle()
        nextButton.isHidden = true
    }
}

extension ChessViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !puzzles.isEmpty && puzzleFinished == false {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let figure = imageValues[indexPath.row]
            
            if figure.last == "W" && teamBlack == false || figure.last == "B" && teamBlack == true {
                if selectedCell != indexPath.row {
                    selectedCell = indexPath.row
                } else {
                    selectedCell = nil
                }
            } else {
                if selectedCell != nil {
                    if checkCorrectMove(position: indexPath.row) {
                        self.makeNextMove(player: true)
                    } else {
                        wrongMoves += 1
                        mistakeNumber.textColor = UIColor.red
                        mistakeNumber.font = UIFont.systemFont(ofSize: 30)
                        mistakeNumber.text = String(wrongMoves)
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension ChessViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ChessCollectionViewCell
        
        if colorToggle {
            cell.backgroundColor = UIColor.darkGray
        } else {
            cell.backgroundColor = UIColor.white
        }
        colorIteration += 1
        if colorIteration == 8 {
            colorIteration = 0
        } else {
            colorToggle.toggle()
        }
        cell.imageView.image = nil
        if imageValues[indexPath.row] != "" {
            cell.imageView.image = UIImage(named: imageValues[indexPath.row])
        }
        
        cell.layer.borderWidth = 0
        if indexPath.row == selectedCell {
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.borderWidth = 3
        }
        
        if let move = computerMoves {
            if indexPath.row == move.0 || indexPath.row == move.1 {
                cell.layer.borderColor = UIColor.yellow.cgColor
                cell.layer.borderWidth = 3
            }
        }
        if puzzleFinished {
            turnLabel.text = "you finished the puzzle!"
        } else {
            turnLabel.text = "Make the best moves for \(teamBlack ? "black" : "white")"
        }
        mistakeText.text = "Mistakes made:"
        mistakeNumber.text = String(wrongMoves)
        
        return cell
    }
}

protocol NewPuzzle {
    func loadNewPuzzle()
}
