//
//  StartViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var startLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap() {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "UserRoomViewController")
        vcName?.modalTransitionStyle = .coverVertical
        self.present(vcName!, animated: true, completion: nil)
    }

}
