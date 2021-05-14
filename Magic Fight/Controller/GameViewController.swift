//
//  GameViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit
import FirebaseDatabase
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var enemyCharacter: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var victoryOrDefeatImage: UIImageView!
    @IBOutlet weak var endTurnButton: UIButton!
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
    
    var soundIntroPlayer = AVAudioPlayer()
    var ref = Database.database().reference()
    var useCard:Card?
        
    var myCards:[Card] = []
    var enemyCards:[Card] = []
    
    var timer = Timer()
    var (minutes,seconds) = (1,0)
    
    var name = ""
    var descriptionLabel = ""
    
    
    var myDeck = [Card]()
    var myTrash = [Card]()
    var enemyDeck = [Card]()
    var enemyTrash = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setDatabase()
        observeDatabase()
        start()
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tapBackground))
        bgImage.addGestureRecognizer(tap1)
        bgImage.isUserInteractionEnabled = true

    }
    
    func observeDatabase() {
        ref.child("battle").child(CURRENT_USER).observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                let value = snapshot.value as! [String : AnyObject]
                
                self.myHPLabel.text = "\(value["HP"]!)"
                self.myMPLabel.text = "\(value["MP"]!)"
                
                guard let hp = value["HP"] else {return}
                if (hp as! Int) <= 0 {
                    self.victoryOrDefeatImage.image = #imageLiteral(resourceName: "defeat")
                    self.victoryOrDefeatImage.isHidden = false
                    self.timer.invalidate()
                }
                
                if value["turn"] as! Bool == true {
                    self.setInitialState()
                    self.start()
                    self.timerLabel.backgroundColor = .clear
                    self.setTurn(isMyturn: true)
                }else {
                    self.timerLabel.backgroundColor = .red
                    self.setTurn(isMyturn: false)
                    self.timerLabel.text = "상대턴"
                    self.timer.invalidate()
                }
                
                guard let deck = value["deck"] else {return}
                
                for name in deck as! [String]{
                    if allCard.filter({$0.name == name}).first != nil {
                    self.myDeck.append(allCard.filter{$0.name == name}.first!)
                    }
                }
                guard let cards = value["cards"] else {return}
                
                var newCards = [Card]()
                for name in cards as! [String]{
                    newCards.append(allCard.filter{$0.name == name}.first ?? Card(name: "스파크", price: 3, usePrice: 1, count: 20, effect: "상대에게 피해를 2 준다.",magicAttribute:.번개,gem: nil,image:UIImage(named: "스파크")!))
                }
                
                self.myCards = newCards
                guard let trash = value["trash"] else {return}
                for name in trash as! [String] {
                    self.myTrash.append(allCard.filter{$0.name == name}.first!)
                }

                self.trashCardLabel.text = "\(self.myTrash.count)"
                self.deckCountLabel.text = "\(self.myDeck.count)"
            }
        })
        
        ref.child("battle").child(OPPONENT_USER).observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                
                let value = snapshot.value as! [String : AnyObject]
                self.enemyHPLabel.text = "\(value["HP"] as? Int ?? 0)"
                self.enemyMPLabel.text = "\(value["MP"] as? Int ?? 0)"
                guard let hp = value["HP"] else {return}

                if (hp as! Int) <= 0 {
                    self.victoryOrDefeatImage.image = #imageLiteral(resourceName: "victory")
                    self.victoryOrDefeatImage.isHidden = false
                    self.timer.invalidate()
                }
                
                guard let showCard = value["useCard"] else {return}
                
                let card = allCard.filter({$0.name == showCard as! String}).first
                
                if card != nil && card?.name != self.useCard?.name {
                    self.showCard(card: card!)
                }
                
                guard let deck = value["deck"] else {return}
                for name in deck as! [String] {
                    if allCard.filter({$0.name == name}).first != nil {
                    self.enemyDeck.append(allCard.filter{$0.name == name}.first!)
                    }
                }
                
                guard let cards = value["cards"] else {return}
                var newCards = [Card]()
                
                for name in cards as! [String]{
                    if allCard.filter({$0.name == name}).first != nil {
                    newCards.append(allCard.filter{$0.name == name}.first!)
                    }
                }
                
                self.enemyCards = newCards
                guard let trash = value["trash"] else {return}
                for name in trash as! [String]{
                    if allCard.filter({$0.name == name}).first != nil {
                    self.enemyTrash.append(allCard.filter{$0.name == name}.first!)
                    }
                }
            
                self.enemyDeckLabel.text = "\(self.enemyDeck.count)"
            }
        })
    }
    
    @IBAction func tapEndTurnButton(_ sender: Any) {
        ref.child("battle").child(CURRENT_USER).updateChildValues(["turn":false])
        ref.child("battle").child(OPPONENT_USER).updateChildValues(["turn":true])
    }
    
    func setDatabase() {
        let turn = CURRENT_USER == "fomagran" ? true:false
        ref.child("battle").child(CURRENT_USER).setValue(["HP":20,"MP":0,"cards":[],"turn":turn,"trash":[],"deck":["초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","초급마법서","푸른젬","푸른젬"]])
        setNameFromDeck()
    }
    
    @objc func tapBackground() {

        if victoryOrDefeatImage.isHidden == false {
            self.ref.removeValue()
            self.performSegue(withIdentifier: "unwindMainViewController", sender: nil)
        }
    }
    
    @IBAction func tapCardButton(_ sender: Any) {
        performSegue(withIdentifier: "showSupplierViewController", sender: nil)
    }
    
    
    func configure() {
        victoryOrDefeatImage.isHidden = true
        let 초급마법서 = allCard.filter{$0.name == "초급마법서"}.first!
        let 푸른젬 = allCard.filter{$0.name == "푸른젬"}.first!
        myDeck = [초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,초급마법서,푸른젬,푸른젬]
        deckCountLabel.text = "\(myDeck.count)"
    }
    
    func setNameFromDeck(){
        
//        for _ in 0...4 {
//        let randomCard = myDeck.randomElement()!
//            myCards.append(myDeck.randomElement()!)
//            myDeck.remove(at: myDeck.firstIndex { $0 == randomCard}!)
//        }
        
        ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":["릴림","화염구","물대포","낙뢰","에너지재생"]])
        ref.child("battle").child(CURRENT_USER).updateChildValues(["deck":myDeck.map{$0.name}])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSupplierViewController" {
            let vc = segue.destination as! SupplierViewController
            vc.myCards = myCards
            vc.isSupplier = false
            vc.myHP = Int(myHPLabel.text!)!
            vc.myMP = Int(myMPLabel.text!)!
            vc.enemyHP = Int(enemyHPLabel.text!)!
            vc.enemyMP = Int(enemyMPLabel.text!)!
            vc.enemyDeck = enemyDeck
            vc.enemyTrash = enemyTrash
            vc.myTrash = myTrash
            vc.myDeck = myDeck
            vc.enemyCards = enemyCards
            vc.myCards = myCards
        }else if segue.identifier == "showShowCardViewController" {
            let vc = segue.destination as! ShowCardViewController

            vc.delegate = self
            vc.showCardImage = useCard!.image
            vc.magic = useCard!.magicAttribute
        }
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
                ref.child("battle").child(CURRENT_USER).updateChildValues(["turn":false])
                ref.child("battle").child(OPPONENT_USER).updateChildValues(["turn":true])
                setTurn(isMyturn: false)
                timer.invalidate()
            }
        }else{
            seconds -= 1
        }

        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
      
        timerLabel.text = "\(minutesString):\(secondsString)"
    }
    
    func setTurn(isMyturn:Bool) {
        if isMyturn {
            cardButton.isEnabled = true
            endTurnButton.isEnabled = true
        }else {
            cardButton.isEnabled = false
            endTurnButton.isEnabled = false
        }
    }
    
    func showCard(card:Card) {
        useCard = card
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "showShowCardViewController", sender: nil)
        }
    }
    
    func playSound(soundName:String) {

        let soundintro = Bundle.main.path(forResource: soundName, ofType: "mp3")
        do {
                soundIntroPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundintro! ))
                    
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                try AVAudioSession.sharedInstance().setActive(true)
            
            }
        
            catch{
                 print(error)
            }
        
        soundIntroPlayer.play()
        
    }
}


extension GameViewController:ShowCardViewControllerDelegate {
    func didDissmiss(magic :Magic) {
        let skView:SKView = {
            var view = SKView()
            if magic == .번개 {
                playSound(soundName: "낙뢰")
                view = SKView(withEmitter: "SparkParticle")
            }else if magic == .불 {
                playSound(soundName: "화염구")
                view = SKView(withEmitter: "FireParticle")
            }else if magic == .물 {
                playSound(soundName: "물벼락")
                view = SKView(withEmitter: "WaterParticle")
            }else if magic == .빛 {
                playSound(soundName: "라파엘")
                view = SKView(withEmitter: "LightParticle")
            }else if magic == .암흑 {
                playSound(soundName: "릴림")
                view = SKView(withEmitter: "DarkParticle")
            }
            return view
        }()
        
        enemyCharacter.image = UIImage(named: "Character_Sick.png")
        enemyCharacter.contentMode = .scaleAspectFill
        view.addSubview(skView)
        
        
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.centerXAnchor.constraint(equalTo:view.centerXAnchor)
                  .isActive = true
        skView.centerYAnchor.constraint(equalTo:view.centerYAnchor)
                  .isActive = true
        skView.heightAnchor.constraint(equalToConstant: 200)
                  .isActive = true
        skView.widthAnchor.constraint(equalToConstant: 500)
                  .isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            skView.isHidden = true
            self.enemyCharacter.image = UIImage(named: "캐릭터.png")
            self.enemyCharacter.contentMode = .scaleAspectFit
        }
    }
}
