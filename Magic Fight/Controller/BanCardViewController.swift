//
//  BanCardViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class BanCardViewController: UIViewController {
    
    @IBOutlet weak var stack4: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var card4Effect: UILabel!
    @IBOutlet weak var card3Effect: UILabel!
    @IBOutlet weak var card2Effect: UILabel!
    @IBOutlet weak var card1Effect: UILabel!
    @IBOutlet weak var card4Label: UILabel!
    @IBOutlet weak var card3Label: UILabel!
    @IBOutlet weak var card2Label: UILabel!
    @IBOutlet weak var card1Label: UILabel!
    @IBOutlet weak var card4: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var card1: UIImageView!
    
    var randomCard1:Card?
    var randomCard2:Card?
    var randomCard3:Card?
    var randomCard4:Card?
    
    var allCardCopy = allCard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTap()
        setNameFromRandomCard()
    }
    
    func setNameFromRandomCard(){
        
        randomCard1 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard1}!)
        (card1Label.text,card1Effect.text) = (randomCard1!.name,randomCard1!.effect)
        
        randomCard2 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard2}!)
        (card2Label.text,card2Effect.text) = (randomCard2!.name,randomCard2!.effect)
        
        randomCard3 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard3}!)
        (card3Label.text,card3Effect.text) = (randomCard3!.name,randomCard3!.effect)
        
        randomCard4 = allCardCopy.randomElement()!
        allCardCopy.remove(at: allCardCopy.firstIndex { $0 == randomCard4}!)
        (card4Label.text,card4Effect.text) = (randomCard4!.name,randomCard4!.effect)
        
    }
    
    func setTap() {
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tapCard1))
        card1Label.addGestureRecognizer(tap1)
        card1Label.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action:#selector(tapCard2))
        card2Label.addGestureRecognizer(tap2)
        card2Label.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action:#selector(tapCard3))
        card3Label.addGestureRecognizer(tap3)
        card3Label.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action:#selector(tapCard4))
        card4Label.addGestureRecognizer(tap4)
        card4Label.isUserInteractionEnabled = true
        
    }
    
    @objc func tapCard1() {
        stack1.isHidden = true
        card1.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard1}!)
    }
    
    @objc func tapCard2() {
        stack2.isHidden = true
        card2.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard2}!)
        
    }
    
    @objc func tapCard3() {
        stack3.isHidden = true
        card3.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard3}!)
    }
    
    @objc func tapCard4() {
        stack4.isHidden = true
        card4.isHidden = true
        allCard.remove(at: allCard.firstIndex{$0 == randomCard4}!)
    }
}
