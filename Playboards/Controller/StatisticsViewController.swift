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
        let chessTimesPlayed = UILabel()
        let chessMistakeAvg = UILabel()
        let tictacTimesPlayed = UILabel()
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.backgroundColor = UIColor.systemBackground
        
        let infoLabels = [chessTimesPlayed, chessMistakeAvg, tictacTimesPlayed]
        for label in infoLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(label)
            label.textColor = UIColor.label
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = UIFont(name: "Noto Sans Kannada", size: 16)
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        
        chessTimesPlayed.text = "Chess games finished: "
        chessMistakeAvg.text = "Average number of mistakes to finish chess puzzle: "
        tictacTimesPlayed.text = "Tic Tac Toe games finished: "
    }
}
