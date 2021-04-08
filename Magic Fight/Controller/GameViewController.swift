//
//  GameViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class GameViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        start()
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
