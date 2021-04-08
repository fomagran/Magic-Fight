//
//  BigCardViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/08.
//

import UIKit

class BigCardViewController: UIViewController {

    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var bigCardDescription: UILabel!
    @IBOutlet weak var bigCardLabel: UILabel!
    @IBOutlet weak var bigCard: UIImageView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.delegate = self
    }
    
    @IBAction func tapUseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tapBackground(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension BigCardViewController:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !self.useButton.frame.contains(touch.location(in: self.view))
    }
}
