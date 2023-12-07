//
//  StatisticsViewController.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 04/12/2023.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBarView()
    }
    
    func setupNavigationBarView() {
        title = "Games statistics"
    }
    
    private func setupView() {
        let tictac = UILabel()
        let tictacTimesPlayed = UILabel()
        let tictacStackView = UIStackView()
        let tictacXWinRate = UILabel()
        let tictacOWinRate = UILabel()
        let chess = UILabel()
        let chessTimesPlayed = UILabel()
        let chessMistakeAverage = UILabel()
        let chessStackView = UIStackView()
        let stackView = UIStackView()
        
        tictacStackView.translatesAutoresizingMaskIntoConstraints = false
        chessStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(stackView)
        
        let infoLabels = [tictac, tictacTimesPlayed, tictacXWinRate, tictacOWinRate, chess, chessTimesPlayed, chessMistakeAverage]
        for label in infoLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = UIColor.label
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = UIFont(name: "Noto Sans Kannada", size: 16)
        }
        for label in [tictac, chess] {
            label.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        }
        
        tictacStackView.addArrangedSubview(tictac)
        tictacStackView.addArrangedSubview(tictacTimesPlayed)
        tictacStackView.addArrangedSubview(tictacXWinRate)
        tictacStackView.addArrangedSubview(tictacOWinRate)
        
        chessStackView.addArrangedSubview(chess)
        chessStackView.addArrangedSubview(chessTimesPlayed)
        chessStackView.addArrangedSubview(chessMistakeAverage)
        
        stackView.addArrangedSubview(tictacStackView)
        stackView.addArrangedSubview(chessStackView)
        
        tictacStackView.backgroundColor = UIColor.systemBackground
        tictacStackView.axis = .vertical
        tictacStackView.spacing = 5
        chessStackView.backgroundColor = UIColor.systemBackground
        chessStackView.axis = .vertical
        chessStackView.spacing = 5
        
        for label in infoLabels {
            label.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9).isActive = true
            label.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tictacStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            chessStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        stackView.backgroundColor = UIColor.label
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        
        tictac.text = "Tic Tac Toe"
        chess.text = "Chess"
        
        let tictacGF = UserDefaults.standard.value(forKey: "tictacGamesFinished") as? Int ?? 0
        let tictacXV = UserDefaults.standard.value(forKey: "xVictories") as? Int ?? 0
        let chessGF = UserDefaults.standard.value(forKey: "chessGamesFinished") as? Int ?? 0
        let chessMA = UserDefaults.standard.value(forKey: "chessMistakeAverage") as? Float ?? 0
        
        let tictacXWR = Float(tictacXV) / Float(tictacGF) * 100
        let tictacOWR = 100 - tictacXWR
        
        tictacTimesPlayed.text = "Games finished: \(tictacGF)"
        tictacXWinRate.text = "X win rate: \(String(format: "%.1f", tictacXWR))%"
        tictacOWinRate.text = "O win rate: \(String(format: "%.1f", tictacOWR))%"
        chessTimesPlayed.text = "Games finished: \(chessGF)"
        chessMistakeAverage.text = "Mistakes average: \(String(format: "%.1f", chessMA))"
    }
}
    
