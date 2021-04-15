//
//  MainViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit
import FirebaseDatabase

class MainViewController: UIViewController {
    
    var ref = Database.database().reference()
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var battleButton: UIButton!
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.style = .large
        activityIndicator.backgroundColor = .black
        activityIndicator.layer.cornerRadius = 20
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameLabel.text = UserDefaults.standard.string(forKey: "nickname")
        self.view.addSubview(self.activityIndicator)
        activityIndicator.isHidden = true
        
        ref.child("battle").child("name").observe(DataEventType.value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
        
            if "\(value)" != UserDefaults.standard.string(forKey: "nickname")! && "\(value)" != "<null>" {
                self.showAlert()
                print(value,UserDefaults.standard.string(forKey: "nickname"))
            }
        })
        
    }
    
    
    @IBAction func tapBattleButton(_ sender: Any) {
        self.activityIndicator.isHidden = false
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
        
        ref.child("battle").setValue(["name":UserDefaults.standard.string(forKey: "nickname")!])
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "매칭 수락하기", message: "수락하시겠습니까?", preferredStyle: .alert)
        let 수락 = UIAlertAction(title: "수락", style: .default) { (_) in
            self.ref.child("battle").setValue(["name":UserDefaults.standard.string(forKey: "nickname")!])
            self.performSegue(withIdentifier: "showBanCardViewController", sender: nil)
        }
        let 거절 = UIAlertAction(title: "거절", style: .cancel) { (_) in
        }
        alert.addAction(수락)
        alert.addAction(거절)
        present(alert, animated: true, completion: nil)
    }
}
