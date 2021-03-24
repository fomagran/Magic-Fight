//
//  LoadingViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/03/24.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToUserRoomViewController()
        }
    
    }
    
    func goToUserRoomViewController() {
        let storyboard: UIStoryboard = self.storyboard!

        let nextView = storyboard.instantiateViewController(withIdentifier: "UserRoomViewController") as! UserRoomViewController

        self.present(nextView, animated: true, completion: nil)
    }
    
}
