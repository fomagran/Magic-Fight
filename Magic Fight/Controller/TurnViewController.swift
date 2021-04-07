//
//  TurnViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class TurnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToGameViewController()
        }
    }
    
    func goToGameViewController() {
        let storyboard: UIStoryboard = self.storyboard!

        let nextView = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController

        self.present(nextView, animated: true, completion: nil)
    }
    
}
