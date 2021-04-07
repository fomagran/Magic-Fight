//
//  MainViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var battleButton: UIButton!
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        // Also show the indicator even when the animation is stopped.
        activityIndicator.hidesWhenStopped = false
        activityIndicator.style = .large
        // Start animation.
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.activityIndicator)
    }
    @IBAction func tapBattleButton(_ sender: Any) {
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "showGameViewController", sender: nil)
        }
    }
}
