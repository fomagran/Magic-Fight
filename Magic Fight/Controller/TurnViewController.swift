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
        let storyboard: UIStoryboard = self.storyboard!

        let nextView = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController

        self.present(nextView, animated: true, completion: nil)
    }
    
}
