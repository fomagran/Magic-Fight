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
        setGameInitialSetting()
        collectionRef.document(documentID).updateData(["turn":CURRENT_USER])
    }
    
    private func setGameInitialSetting() {
        let cards:[Card] =  [푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,초급마법서,초급마법서]
        
        for card in cards {
            collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").addDocument(data:card.toDictionary!)
        }
    
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)HP":20,"\(CURRENT_USER)MP":0,"turnLastDocument":turnLastDocument])
        setTurn()
    }
    
    func setTurn() {
        collectionRef.document(documentID).getDocument { snapshot, error in
            let user1 = snapshot?.get("user1") as? String ?? ""
            if user1 == CURRENT_USER {
                self.image.image = #imageLiteral(resourceName: "선공")
            }else {
                self.image.image = #imageLiteral(resourceName: "후공")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.goToGameViewController()
            }
        }
    }
    
    func goToGameViewController() {
        performSegue(withIdentifier: "showGameViewController", sender: nil)
    }
}
