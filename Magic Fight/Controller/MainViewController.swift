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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
    }
    
    private func configure() {
        nicknameLabel.text = UserDefaults.standard.string(forKey: "nickname")
        self.view.addSubview(self.activityIndicator)
        activityIndicator.isHidden = true
        observeRoom()
    }
    
    private func observeRoom() {
        Firestore.firestore().collection("WaitList").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            if !snapshot.documents.isEmpty {
                documentID = snapshot.documents.first?.documentID ?? ""
                self.showAlert()
            }
        }
    }
    
    private func enterRoom() {
        if documentID != CURRENT_USER {
            Firestore.firestore().collection("WaitList").document(documentID).updateData(["user2":CURRENT_USER])
        }else {
            Firestore.firestore().collection("WaitList").document(documentID).getDocument { snapshot,error in
                guard let snapshot = snapshot else { return }
                let user1 = snapshot.get("user1") as? String ?? ""
                let user2 = snapshot.get("user2") as? String ?? ""
                collectionRef.document(CURRENT_USER).setData(["user1":user1,"user2":user2])
                Firestore.firestore().collection("WaitList").document(CURRENT_USER).delete()
            }
        }
        self.activityIndicator.isHidden = true
        self.performSegue(withIdentifier: "showBanCardViewController", sender: nil)
    }
    
    private func createRoom() {
        Firestore.firestore().collection("WaitList").document(CURRENT_USER).setData(["user1":CURRENT_USER])
        documentID = CURRENT_USER
        listener = Firestore.firestore().collection("WaitList").document(CURRENT_USER).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            if snapshot.get("user2") != nil {
                self.showAlert()
                self.listener?.remove()
            }
        }
    }
    
    @IBAction func unwindToMainViewController (segue : UIStoryboardSegue) {
    }
    
    @IBAction func tapBattleButton(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        createRoom()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "매칭 수락하기", message: "수락하시겠습니까?", preferredStyle: .alert)
        let 수락 = UIAlertAction(title: "수락", style: .default) { (_) in
            self.enterRoom()
        }
        alert.addAction(수락)
        self.present(alert, animated: false, completion: nil)
    }
}
