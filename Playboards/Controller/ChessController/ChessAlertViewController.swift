//
//  ChessAlertViewController.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 03/12/2023.
//

import UIKit

protocol CustomAlertDelegate {
    func FindButtonTapped()
}

class ChessAlertViewController: UIViewController {
    
    static let controllerIdentifier = String(describing: ChessAlertViewController.self)

    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var difficultySlider: UISlider!
    @IBOutlet weak var findButton: UIButton!
    var delegate: CustomAlertDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentDifficulty = UserDefaults.standard.value(forKey: "currentDifficulty") as? Float ?? difficultySlider.minimumValue
        difficultySlider.value = currentDifficulty
        difficultySlider.minimumValue = Float(600)
        difficultySlider.maximumValue = Float(3000)
        difficultyLabel.text = String(format: "%.0f", difficultySlider.value)
    }
    
    init() {
        super.init(nibName: ChessAlertViewController.controllerIdentifier, bundle: Bundle(for: ChessAlertViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    @IBAction func sliderValueChange(_ sender: Any) {
        UserDefaults.standard.set(difficultySlider.value, forKey: "currentDifficulty")
        difficultyLabel.text = String(format: "%.0f", difficultySlider.value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findButtonTapped(_ sender: Any) {
//        ChessViewController().difficulty = Int(difficultySlider.value)
        delegate?.FindButtonTapped()
        self.dismiss(animated: true)
    }
}
