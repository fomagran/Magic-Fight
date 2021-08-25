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
    
    private func configure() {
        nicknameLabel.text = UserDefaults.standard.string(forKey: "nickname")
        self.view.addSubview(self.activityIndicator)
        activityIndicator.isHidden = true
        observeRoom()
    }
    
    private func observeRoom() {
        collectionRef.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            if !snapshot.documents.isEmpty {
                documentID = snapshot.documents.first?.documentID ?? ""
                OPPONENT_USER = snapshot.documents.first?.get("user1") as? String ?? ""
                self.showAlert()
            }
        })
    }
    
    private func enterRoom() {
        collectionRef.document(documentID).updateData(["user2":CURRENT_USER])
        self.activityIndicator.isHidden = true
        self.performSegue(withIdentifier: "showBanCardViewController", sender: nil)
    }
    
    private func createRoom() {
        collectionRef.addDocument(data: ["user1":CURRENT_USER])
        self.performSegue(withIdentifier: "showBanCardViewController", sender: nil)
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
        present(alert, animated: true, completion: nil)
    }
}
