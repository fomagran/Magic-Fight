//
//  BanCardViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit
import FirebaseDatabase

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
    
    var ref = Database.database().reference()
    var opponentConfirm = false
    
    var allCardCopy = allCard.filter{$0.gem == nil}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTap()
        setNameFromRandomCard()
        ref.child("battle").child("isReady").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                if snapshot.value as! String == "아직" {
                    self.opponentConfirm = true
                }else{
                    self.performSegue(withIdentifier: "showTurnViewController", sender: nil)
                }
            }
        })
    }
    
    @IBAction func tapDoneBttn(_ sender: Any) {
        if opponentConfirm == true {
            ref.child("battle").setValue(["isReady":"됐어"])
           performSegue(withIdentifier: "showTurnViewController", sender: nil)
        }else {
            self.opponentConfirm = true
            self.doneBtn.isHidden = true
            self.pickBanCard.text = "YOU READY"
            ref.child("battle").setValue(["isReady":"아직"])
        }
    }
    func setNameFromRandomCard(){
        
        randomCard1 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard1}!)
        card1.image = randomCard1?.image
       
        
        randomCard2 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard2}!)
        card2.image = randomCard2?.image
     
        
        randomCard3 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard3}!)
        card3.image = randomCard3?.image
       
        randomCard4 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard4}!)
        card4.image = randomCard4?.image

        
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
    }
    
    @objc func tapCard2() {

        card2.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard2}!)
        
    }
    
    @objc func tapCard3() {
  
        card3.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard3}!)
    }
    
    @objc func tapCard4() {

        card4.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard4}!)
    }
}
