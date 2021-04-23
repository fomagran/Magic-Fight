//
//  LoadingViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/23.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func tapConfirmButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showMainViewController", sender: nil)
    }
}
