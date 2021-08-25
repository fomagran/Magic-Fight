//
//  TurnViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit
import FirebaseFirestore

class TurnViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToGameViewController()
        }
        
        collectionRef.document(documentID).getDocument { snapshot, error in
            let turn = snapshot?.get("turn") as? String ?? ""
            if turn == CURRENT_USER {
                self.image.image = #imageLiteral(resourceName: "후공")
            }else {
                self.image.image = #imageLiteral(resourceName: "선공")
            }
        }
    }
    
    func goToGameViewController() {
        performSegue(withIdentifier: "showGameViewController", sender: nil)
    }
}
