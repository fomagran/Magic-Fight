//
//  BanCardViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class BanCardViewController: UIViewController {
    
    @IBOutlet weak var card4Label: UILabel!
    @IBOutlet weak var card3Label: UILabel!
    @IBOutlet weak var card2Label: UILabel!
    @IBOutlet weak var card1Label: UILabel!
    @IBOutlet weak var card4: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var card1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTap()
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
        card1.isHidden = true
        card1Label.isHidden = true
    }
    
    @objc func tapCard2() {
        card2.isHidden = true
        card2Label.isHidden = true
    }
    
    @objc func tapCard3() {
        card3.isHidden = true
        card3Label.isHidden = true
    }
    
    @objc func tapCard4() {
        card4.isHidden = true
        card4Label.isHidden = true
    }
}
