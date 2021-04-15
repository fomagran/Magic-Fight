//
//  GameViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit
import FirebaseDatabase

class GameViewController: UIViewController {

    @IBOutlet weak var enemyDeckLabel: UILabel!
    @IBOutlet weak var deckCountLabel: UILabel!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var magicAttributeImageView: UIImageView!
    @IBOutlet weak var trashCardLabel: UILabel!
    @IBOutlet weak var myMPLabel: UILabel!
    @IBOutlet weak var myHPLabel: UILabel!
    @IBOutlet weak var enemyMPLabel: UILabel!
    @IBOutlet weak var enemyHPLabel: UILabel!
    @IBOutlet weak var logLabel: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var ref = Database.database().reference()
    
    var cards:[Card] = []
    
    var timer = Timer()
    var (minutes,seconds) = (1,0)
    
    var name = ""
    var descriptionLabel = ""
    
    var deck = [Card]()
    var trash = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setDatabase()
        start()
        
        ref.child("battle").child(CURRENT_USER).observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                let value = snapshot.value as! [String : AnyObject]
                if "\(value["HP"]!)" == "0" {
                    self.showAlert(title:"Lose" ,message:"아쉽게 패배하셨네요ㅜ")
                }
                
                self.myHPLabel.text = "\(value["HP"]!)"
                self.myMPLabel.text = "\(value["MP"]!)"
                self.trashCardLabel.text = "\(value["trash"]!)"
                self.deckCountLabel.text = "\(value["deck"]!.count!)"
            }
        })
        
        ref.child("battle").child(OPPONENT_USER).observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                let value = snapshot.value as! [String : AnyObject]
                if "\(value["HP"]!)" == "0" {
                    self.showAlert(title:"Victory" ,message:"승리를 축하드려요!")
                }
                self.enemyHPLabel.text = "\(value["HP"]!)"
                self.enemyMPLabel.text = "\(value["MP"]!)"
                self.enemyDeckLabel.text = "\(value["deck"]!.count!)"
            }
        })
    }
    
    func showAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (_) in
            self.ref.removeValue()
            self.performSegue(withIdentifier: "unwindMainViewController", sender: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func setDatabase() {
        ref.child("battle").child(CURRENT_USER).setValue(["HP":20,"MP":0,"turn":true,"trash":0,"deck":["초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","푸른젬","푸른젬"]])
        
    }
    
    @IBAction func tapCardButton(_ sender: Any) {
        performSegue(withIdentifier: "showSupplierViewController", sender: nil)
    }
    
    
    func configure() {
        let 초급마법서 = Card(name: "초급 마법서", price: 0, usePrice: 1, count: 0, effect: "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다.",magicAttribute:.무속성,gem: nil)
        let 푸른젬 =      Card(name: "푸른 젬", price: 1,usePrice: 0, count: 30, effect: "",magicAttribute:.무속성 ,gem:1)
        deck = [초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,푸른젬,푸른젬]
        deckCountLabel.text = "\(deck.count)"
        setNameFromDeck()
    }
    
    func setNameFromDeck(){
        
        for _ in 0...4 {
        let randomCard = deck.randomElement()!
        cards.append(deck.randomElement()!)
        deck.remove(at: deck.firstIndex { $0 == randomCard}!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSupplierViewController" {
            let vc = segue.destination as! SupplierViewController
            vc.cards = cards
            vc.isSupplier = false
            vc.myHP = Int(myHPLabel.text!)!
            vc.enemyHP = Int(enemyHPLabel.text!)!
        }
    }
    
  
    
   func reset(_ sender: Any) {
        timer.invalidate()
        (minutes,seconds) = (1,0)
        timerLabel.text = "1:00"
    }
    
    func start() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.keepTimer), userInfo: nil, repeats: true)

    }
    
    @objc private func stopTimer() {
        timer.invalidate()
    }
    
    //처음상태로 세팅
    private func setInitialState() {
        timer.invalidate()
        (minutes,seconds) = (1,0)
        timerLabel.text = "01:00"
    }
    
    @objc private func keepTimer(){
        if seconds == 0 {
            if minutes == 1 {
            minutes -= 1
            seconds = 59
            }else{
                timer.invalidate()
            }
        }else{
            seconds -= 1
        }

        
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
      
        timerLabel.text = "\(minutesString):\(secondsString)"
    }
}
