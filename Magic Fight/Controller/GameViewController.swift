//
//  GameViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var card5Label: UILabel!
    @IBOutlet weak var card4Label: UILabel!
    @IBOutlet weak var card3Label: UILabel!
    @IBOutlet weak var card2Label: UILabel!
    @IBOutlet weak var card1Label: UILabel!
    @IBOutlet weak var card5: UIImageView!
    @IBOutlet weak var card4: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var card1: UIImageView!
    @IBOutlet weak var magicAttributeImageView: UIImageView!
    @IBOutlet weak var trashCardLabel: UILabel!
    @IBOutlet weak var myMPLabel: UILabel!
    @IBOutlet weak var myHPLabel: UILabel!
    @IBOutlet weak var enemyMPLabel: UILabel!
    @IBOutlet weak var enemyHPLabel: UILabel!
    @IBOutlet weak var logLabel: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var (minutes,seconds) = (1,0)
    
    var name = ""
    var descriptionLabel = ""
    let 초급마법서 = Card(name: "초급 마법서", price: 0, usePrice: 1, count: 0, effect: "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다.",magicAttribute:.무속성)
    let 푸른젬 =  GemCard(name: "푸른 젬", price: 1, gem: 1, count: 30)
    var deck = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        start()
        setTap()
    }
    
    func configure() {
        deck = [초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,푸른젬,푸른젬]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BigCardViewController" {
            let vc = segue.destination as! BigCardViewController
            vc.bigCardLabel.text = name
            vc.bigCardDescription.text = descriptionLabel
        }
    }
    
    func setTap() {
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tapCard1))
        card1Label.addGestureRecognizer(tap1)
        card1Label.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action:#selector(tapCard2))
        card2Label.addGestureRecognizer(tap2)
        card2Label.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action:#selector(tapCard3))
        card3Label.addGestureRecognizer(tap3)
        card3Label.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action:#selector(tapCard4))
        card4Label.addGestureRecognizer(tap4)
        card4Label.isUserInteractionEnabled = true
        
        let tap5 = UITapGestureRecognizer(target: self, action:#selector(tapCard5))
        card5Label.addGestureRecognizer(tap5)
        card5Label.isUserInteractionEnabled = true
        
    }
    
    @objc func tapCard1() {
        name = card1Label.text ?? ""
        descriptionLabel = "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다."
        performSegue(withIdentifier: "showBigCardViewController", sender: nil)
    }
    
    @objc func tapCard2() {
        name = card1Label.text ?? ""
        descriptionLabel = "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다."
        performSegue(withIdentifier: "showBigCardViewController", sender: nil)
    }
    
    @objc func tapCard3() {
        name = card1Label.text ?? ""
        descriptionLabel = "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다."
        performSegue(withIdentifier: "showBigCardViewController", sender: nil)
    }
    
    @objc func tapCard4() {
        name = card1Label.text ?? ""
        descriptionLabel = "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다."
        performSegue(withIdentifier: "showBigCardViewController", sender: nil)
    }
    
    @objc func tapCard5() {
        name = card1Label.text ?? ""
        descriptionLabel = "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다."
        performSegue(withIdentifier: "showBigCardViewController", sender: nil)
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
