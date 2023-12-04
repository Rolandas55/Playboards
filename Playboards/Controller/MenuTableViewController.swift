//
//  MenuTableViewController.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 26/11/2023.
//

import UIKit
import CoreData

class MenuTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    var playboards = [Playboards]()
    
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
        //loadCoreData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        tableView.separatorStyle = .none
    }
    
    @IBAction func StatisticsButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(StatisticsViewController(), animated: true)
    }
    
    func updateData() {
        let entity = NSEntityDescription.entity(forEntityName: "Playboards", in: self.managedObjectContext!)
        let coreDataList = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
    }
}

// MARK: - CoreData logic
extension MenuTableViewController {
    func loadCoreData() {
        let request: NSFetchRequest = Playboards.fetchRequest()
        do {
            let result = try managedObjectContext?.fetch(request)
            playboards = result!
        } catch {
            fatalError("Error in loading item into core data")
        }
    }
    
    func saveCoreData() {
        do {
            try managedObjectContext?.save()
        } catch {
            fatalError("Error in saving item into core data")
        }
        loadCoreData()
    }
}

extension MenuTableViewController {
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
