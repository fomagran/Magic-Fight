//
//  MainViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

class MainViewController: UIViewController {
    
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
        
    }
    
    
    @IBAction func tapBattleButton(_ sender: Any) {
        self.activityIndicator.isHidden = false
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.activityIndicator.isHidden = true
            self.showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "매칭 수락하기", message: "수락하시겠습니까?", preferredStyle: .alert)
        let 수락 = UIAlertAction(title: "수락", style: .default) { (_) in
            self.performSegue(withIdentifier: "showBanCardViewController", sender: nil)
        }
        let 거절 = UIAlertAction(title: "거절", style: .cancel) { (_) in
        }
        alert.addAction(수락)
        alert.addAction(거절)
        present(alert, animated: true, completion: nil)
    }
}
