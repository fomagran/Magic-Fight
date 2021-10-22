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
    
    func showAlert(title:String) {
        let alert = UIAlertController(title: title, message:title, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (_) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func checkOverlap(completion:@escaping(Bool)->Void) {
        Firestore.firestore().collection("User").whereField("nickName",isEqualTo:nickNameTF.text ?? "").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return completion(false) }
            if !snapshot.documents.isEmpty {
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
                if overlap {
                    self.showAlert(title: "닉네임이 중복되었습니다.")
                    return
                }
            })
            loadingLabel.isHidden = false
            UserDefaults.standard.setValue(nickNameTF.text!, forKey: "nickname")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "showMainViewController", sender: nil)
            }
        }
    }
    @IBAction func tapBackground(_ sender: Any) {
        self.view.endEditing(true)
    }
}


