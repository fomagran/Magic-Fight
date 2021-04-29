//
//  TurnViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class TurnViewController: UIViewController {

    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLabel.layer.cornerRadius = 20
        firstLabel.layer.masksToBounds = true
        
        afterLabel.layer.cornerRadius = 20
        afterLabel.layer.masksToBounds = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToGameViewController()
        }
        
        if OPPONENT_USER == "acop" {
            firstLabel.backgroundColor = .red
            afterLabel.backgroundColor = . black
        }else {
            firstLabel.backgroundColor = .black
            afterLabel.backgroundColor = . red
        }
    }
    
    func goToGameViewController() {
        performSegue(withIdentifier: "showGameViewController", sender: nil)
    }
    
}
