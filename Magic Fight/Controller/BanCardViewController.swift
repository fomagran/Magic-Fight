//
//  BanCardViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class BanCardViewController: UIViewController {
    
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
    }
    
    @objc func tapCard2() {
        card2.isHidden = true
    }
    
    @objc func tapCard3() {
        card3.isHidden = true
    }
    
    @objc func tapCard4() {
        card4.isHidden = true
    }
}
