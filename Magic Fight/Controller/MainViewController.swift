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
    var dataArray:[[[String]]] = []
    
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
//        getGameData()
        configure()
        observeRoom()
    }
    
    func getGameData() {
        Firestore.firestore().collection("Record").order(by: "timeStamp").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            self.dataArray = Array(repeating: [[String]](), count: snapshot.documents.count)
            for (i,document) in snapshot.documents.enumerated() {
                self.getUsedCarddata(documentID: document.documentID,index: i)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            for (i,data) in self.dataArray.enumerated() {
                print("\(i+1)번째 게임")
                for (j,d) in data.enumerated() {
                    print("\(j+1)번째턴 \(d)")
                }
            }
        }
    }
    
    func getUsedCarddata(documentID:String,index:Int) {
        Firestore.firestore().collection("Record").document(documentID).collection("Turn").order(by: "timeStamp").getDocuments(completion: { snapshot, error in
            guard let snapshot1 = snapshot else { return }
            self.dataArray[index] = Array(repeating: [String](), count: snapshot1.documents.count)
            for (i,document) in snapshot1.documents.enumerated() {
                self.dataArray[index][i].append("사용한 시간 \(document.get("turnTime") ?? "00:50")")
                Firestore.firestore().collection("Record").document(documentID).collection("Turn").document(document.documentID).collection("UsedCard").getDocuments { snapshot, error in
                    guard let snapshot2 = snapshot else { return }
                    if snapshot2.documents.isEmpty {
                        self.dataArray[index][i].append("사용한 카드 없음")
                    }else {
                        for doc in snapshot2.documents {
                            self.dataArray[index][i].append("사용한 카드 \(doc.get("card")!)")
                        }
                    }
                }
                Firestore.firestore().collection("Record").document(documentID).collection("Turn").document(document.documentID).collection("BoughtCard").getDocuments { snapshot, error in
                    guard let snapshot2 = snapshot else { return }
                    if snapshot2.documents.isEmpty {
                        self.dataArray[index][i].append("구매한 카드 없음")
                    }else {
                        for doc in snapshot2.documents {
                            self.dataArray[index][i].append("구매한 카드 \(doc.get("card")!)")
                        }
                    }
                }
            }
        })
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
        let waitDocument = Firestore.firestore().collection("WaitList").addDocument(data: ["user1":CURRENT_USER]).documentID
//        recordDocument = recordRef.addDocument(data: ["timeStamp":FieldValue.serverTimestamp()]).documentID
//        Firestore.firestore().collection("WaitList").document(CURRENT_USER).updateData(["recordDocument":recordDocument])
//        turnLastDocument = recordRef.document(recordDocument).collection("Turn").addDocument(data: ["timeStamp":FieldValue.serverTimestamp()]).documentID
        documentID = waitDocument
    }
    
    private func observeRoom() {
        listener =  Firestore.firestore().collection("WaitList").addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            if !snapshot.documents.isEmpty {
                let first = snapshot.documents.first
                let firstDocumentID = snapshot.documents.first!.documentID
                documentID = firstDocumentID
                let user1 = first?.get("user1")
                let user2 = first?.get("user2")
//                recordDocument = first?.get("recordDocument") as? String ?? ""
                
                if user1 as? String ?? "" == CURRENT_USER {
                    OPPONENT_USER = user2 as? String ?? ""
                }else {
                    OPPONENT_USER = user1 as? String ?? ""
                }
                
                if let user1 = user1,let user2 = user2 {
                    collectionRef.document(documentID).setData(["user1":user1 as! String,"user2":user2 as! String])
                }
                
                if user1 != nil && user2 != nil {
                    Firestore.firestore().collection("WaitList").document(documentID).delete()
                    self.activityIndicator.isHidden = true
                    self.performSegue(withIdentifier: "showTurnViewController", sender: nil)
                }
            }
        })
    }
    
    @IBAction func unwindToMainViewController (segue : UIStoryboardSegue) {
        MY_CARDS = []
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
