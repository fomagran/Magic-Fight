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
        
        if UserDefaults.standard.string(forKey: "nickname") != nil {
            bgView.isHidden = true
            loadingLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "showMainViewController", sender: nil)
            }
            
        }else {
            loadingLabel.isHidden = true
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: title, message: "닉네임을 정해주세요!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (_) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tapConfirmButton(_ sender: Any) {
        if nickNameTF.text == "" {
            showAlert()
        }else {
            loadingLabel.isHidden = false
            UserDefaults.standard.setValue(nickNameTF.text!, forKey: "nickname")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "showMainViewController", sender: nil)
            }
        }
    }
}
