//
//  MainViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit
import FirebaseFirestore

class MainViewController: UIViewController {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var battleButton: UIButton!
    
    var ready:[Bool] = []
    var listener:ListenerRegistration?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.style = .large
        activityIndicator.backgroundColor = .black
        activityIndicator.layer.cornerRadius = 20
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        observeRoom()
    }
    
    private func configure() {
        nicknameLabel.text = UserDefaults.standard.string(forKey: "nickname")
        self.view.addSubview(self.activityIndicator)
        activityIndicator.isHidden = true
    }
    
    private func enterRoom() {
        if documentID != CURRENT_USER {
            Firestore.firestore().collection("WaitList").document(documentID).updateData(["user2":CURRENT_USER])
        }
    }
    
    private func createRoom() {
        Firestore.firestore().collection("WaitList").document(CURRENT_USER).setData(["user1":CURRENT_USER])
        documentID = CURRENT_USER
    }
    
    private func observeRoom() {
        listener =  Firestore.firestore().collection("WaitList").addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            if !snapshot.documents.isEmpty {
                let first = snapshot.documents.first
                let user1 = first?.get("user1")
                let user2 = first?.get("user2")
    
                if user1 as? String ?? "" == CURRENT_USER {
                    OPPONENT_USER = user2 as? String ?? ""
                }else {
                    OPPONENT_USER = user1 as? String ?? ""
                }
                
                if user1 != nil && user2 != nil {
                    Firestore.firestore().collection("WaitList").document(CURRENT_USER).delete()
                    collectionRef.document(CURRENT_USER).setData(["user1":user1 as! String,"user2":user2 as! String])
                    self.performSegue(withIdentifier: "showTurnViewController", sender: nil)
                }
            }
        })
    }
    
    @IBAction func unwindToMainViewController (segue : UIStoryboardSegue) {
    }
    
    @IBAction func tapBattleButton(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Firestore.firestore().collection("WaitList").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            if snapshot.documents.isEmpty {
                self.createRoom()
            }else {
                documentID = snapshot.documents.first?.documentID ?? ""
                self.showAlert()
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "매칭 수락하기", message: "수락하시겠습니까?", preferredStyle: .alert)
        let 수락 = UIAlertAction(title: "수락", style: .default) { (_) in
            self.ready.append(true)
            self.enterRoom()
        }
        alert.addAction(수락)
        self.present(alert, animated: false, completion: nil)
    }
}
