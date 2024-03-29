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
    }
    
    @IBAction func tapDoneBttn(_ sender: Any) {
            ready.append(true)
            collectionRef.document(documentID).updateData(["ready":ready])
            self.doneBtn.isHidden = true
            self.pickBanCard.text = "YOU READY"
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
