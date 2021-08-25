//
//  ShowCardViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/05/13.
//

import UIKit

protocol ShowCardViewControllerDelegate:AnyObject {
    func didDissmiss(magic:String)
}

class ShowCardViewController: UIViewController {
    
    weak var delegate:ShowCardViewControllerDelegate?
    var magic:String!
    var showCardImage:UIImage!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardImageView.image = showCardImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.didDissmiss(magic:self.magic)
        }
    }
    
}
