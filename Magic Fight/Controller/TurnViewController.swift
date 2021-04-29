//
//  TurnViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class TurnViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToGameViewController()
        }
        
        if OPPONENT_USER == "acop" {
            image.image = #imageLiteral(resourceName: "선공")
        }else {
            image.image = #imageLiteral(resourceName: "후공")
        }
    }
    
    func goToGameViewController() {
        performSegue(withIdentifier: "showGameViewController", sender: nil)
    }
    
}
