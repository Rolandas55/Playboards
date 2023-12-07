//
//  MenuTableViewController.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 26/11/2023.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    enum PlayMode {
        case twoPlayer
        case vsComputer
        case multiplayer
    }
    
    struct Game {
        var name: String
        var mode: [PlayMode]
        var menuImageName: String
        var storyboard: Bool
        var controllerID: String?
        var controller: UIViewController?
    }
    
    let games = [Game(name: "Tic Tac Toe", mode:[.twoPlayer], menuImageName: "TicTacToe", storyboard: true, controllerID: "ticTacToe"),
                 //Game(name: "BattleShip", mode: [.twoPlayer, .vsComputer], menuImageName: "Battleship", storyboard: false),
                 Game(name: "Chess", mode: [.vsComputer], menuImageName: "Chess", storyboard: false, controller: ChessViewController())//,
                 //Game(name: "MineSweeper", mode: [.vsComputer], menuImageName: "Minesweeper", storyboard: false)
                ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    @IBAction func StatisticsButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(StatisticsViewController(), animated: true)
    }
}

extension MenuTableViewController {
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? MenuTableViewCell else {return UITableViewCell()}

        cell.title.text = games[indexPath.row].name
        cell.backImage = UIImageView(image: UIImage(named: games[indexPath.row].menuImageName))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if games[indexPath.row].storyboard && games[indexPath.row].controllerID != nil {
            guard let gameVC = self.storyboard?.instantiateViewController(withIdentifier: games[indexPath.row].controllerID ?? "") as? UIViewController else { return }
            navigationController?.pushViewController(gameVC, animated: true)
        } else if let controller = games[indexPath.row].controller {
            navigationController?.pushViewController(controller, animated: true)
        }
        print(games[indexPath.row].name)
    }
}
