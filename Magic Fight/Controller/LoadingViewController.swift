//
//  LoadingViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/23.
//

import UIKit
import FirebaseFirestore

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardObserver()
        
        if UserDefaults.standard.string(forKey: "Nickname") != nil {
            bgView.isHidden = true
            loadingLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "showMainViewController", sender: nil)
            }
        }else {
            loadingLabel.isHidden = true
        }
    }
    
    func showAlert(title:String) {
        let alert = UIAlertController(title: title, message:"다른 닉네임을 사용해주세요!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (_) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func checkOverlap(completion:@escaping(Bool)->Void) {
        Firestore.firestore().collection("User").document(nickNameTF.text ?? "").getDocument { snapshot, error in
            guard let snapshot = snapshot else { return completion(false) }
            if let _ = snapshot.get("nickname") {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    
    
    @IBAction func tapConfirmButton(_ sender: Any) {
        if nickNameTF.text == "" {
            showAlert(title: "닉네임을 정해주세요!")
        }else {
            checkOverlap(completion:{ overlap in
                if !overlap {
                    self.loadingLabel.isHidden = false
                    UserDefaults.standard.setValue(self.nickNameTF.text!, forKey: "Nickname")
                    Firestore.firestore().collection("User").document(self.nickNameTF.text!).setData(["nickname" : self.nickNameTF.text!])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.performSegue(withIdentifier: "showMainViewController", sender: nil)
                    }
                }else {
                    self.showAlert(title: "닉네임이 중복되었습니다.")
                }
            })
        }
    }
    @IBAction func tapBackground(_ sender: Any) {
        self.view.endEditing(true)
    }
}


