//
//  SettingViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/05/07.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapBackground(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapQuitGameButton(_ sender: Any) {
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)HP":0])
    }
}
