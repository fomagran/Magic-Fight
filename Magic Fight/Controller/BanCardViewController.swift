//
//  BanCardViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class BanCardViewController: UIViewController {
    
    @IBOutlet weak var pickBanCard: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var card4: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var card1: UIImageView!
    
    var randomCard1:Card?
    var randomCard2:Card?
    var randomCard3:Card?
    var randomCard4:Card?
    
    var ready:[Bool] = []
    var allCardCopy = allCard.filter{$0.gem == nil}
    var listener:ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTap()
        setNameFromRandomCard()
        observeRoom()
    }
    
    private func observeRoom() {
        listener =  collectionRef.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            if !snapshot.documents.isEmpty {
                let first = snapshot.documents.first
                let user1 = first?.get("user1") as? String ?? ""
                let user2 = first?.get("user2") as? String ?? ""
                if user1 == CURRENT_USER {
                    OPPONENT_USER = user2
                }else {
                    OPPONENT_USER = user1
                }
                self.ready = first?.get("ready") as? [Bool] ?? []
                if self.ready.count == 2 {
                    self.ready.append(true)
                    collectionRef.document(documentID).updateData(["ready":self.ready])
                    self.listener?.remove()
                    self.performSegue(withIdentifier: "showTurnViewController", sender: nil)
                }
            }
        })
    }
    
    private func setGameInitialSetting() {
        let cards:[Card] = [푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,푸른젬,초급마법서,초급마법서]
        for card in cards {
            collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").addDocument(data:card.toDictionary!)
        }
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)HP":20,"\(CURRENT_USER)MP":0])
        detectUser1()
    }
    
    func detectUser1() {
        collectionRef.document(documentID).getDocument { snapshot, error in
            let user1 = snapshot?.get("user1") as? String ?? ""
            collectionRef.document(documentID).updateData(["turn":user1])
        }
    }
    
    @IBAction func tapDoneBttn(_ sender: Any) {
            ready.append(true)
            collectionRef.document(documentID).updateData(["ready":ready])
            self.doneBtn.isHidden = true
            self.pickBanCard.text = "YOU READY"
            setGameInitialSetting()
    }
    
    func setNameFromRandomCard(){
        
        randomCard1 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard1}!)
        card1.image = UIImage(named: randomCard1?.image ?? "스파크")
       
        randomCard2 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard2}!)
        card2.image = UIImage(named: randomCard2?.image ?? "스파크")
     
        randomCard3 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard3}!)
        card3.image = UIImage(named: randomCard3?.image ?? "스파크")
       
        randomCard4 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard4}!)
        card4.image = UIImage(named: randomCard4?.image ?? "스파크")

    }
    
    func setTap() {
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tapCard1))
        card1.addGestureRecognizer(tap1)
        card1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action:#selector(tapCard2))
        card2.addGestureRecognizer(tap2)
        card2.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action:#selector(tapCard3))
        card3.addGestureRecognizer(tap3)
        card3.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action:#selector(tapCard4))
        card4.addGestureRecognizer(tap4)
        card4.isUserInteractionEnabled = true
        
    }
    
    @objc func tapCard1() {
        card1.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard1}!)
        Firestore.firestore().collection("Battle").document(documentID).collection("BanCard").addDocument(data: ["banCard":randomCard1?.name ?? ""])
    }
    
    @objc func tapCard2() {
        card2.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard2}!)
        Firestore.firestore().collection("Battle").document(documentID).collection("BanCard").addDocument(data: ["banCard":randomCard1?.name ?? ""])
        
    }
    
    @objc func tapCard3() {
        card3.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard3}!)
        Firestore.firestore().collection("Battle").document(documentID).collection("BanCard").addDocument(data: ["banCard":randomCard1?.name ?? ""])
    }
    
    @objc func tapCard4() {
        card4.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard4}!)
        Firestore.firestore().collection("Battle").document(documentID).collection("BanCard").addDocument(data: ["banCard":randomCard1?.name ?? ""])
    }
}
