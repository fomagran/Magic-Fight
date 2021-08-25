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
import FirebaseFirestore

class GameViewController: UIViewController {

    @IBOutlet weak var supplierButton: UIButton!
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
    var useCardString:String = ""
    
    var isSupplier:Bool = false
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
//        setDatabase()
//        observeDatabase()
        observeUserInfo()
        start()
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tapBackground))
        bgImage.addGestureRecognizer(tap1)
        bgImage.isUserInteractionEnabled = true
        
    }
    
    func observeUserInfo() {
        collectionRef.document(documentID).addSnapshotListener { snapshot, error in
            self.myHPLabel.text =  "\(snapshot?.get("\(CURRENT_USER)HP") as? Int ?? 0)"
            self.myMPLabel.text =  "\(snapshot?.get("\(CURRENT_USER)MP") as? Int ?? 0)"
            self.enemyHPLabel.text =  "\(snapshot?.get("\(OPPONENT_USER)HP") as? Int ?? 0)"
            self.enemyMPLabel.text =  "\(snapshot?.get("\(OPPONENT_USER)MP") as? Int ?? 0)"
            
            if (snapshot?.get("turn") as? String ?? "") == CURRENT_USER {
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
            
        }
    }
    
    func observeDatabase() {
        ref.child("battle").child(CURRENT_USER).observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                let value = snapshot.value as! [String : AnyObject]
                
                self.myHPLabel.text = "\(value["HP"]!)"
                self.myMPLabel.text = "\(value["MP"]!)"
                
                if let hp = value["HP"] {
                    
                    if (hp as! Int) <= 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.victoryOrDefeatImage.image = #imageLiteral(resourceName: "defeat")
                            self.victoryOrDefeatImage.isHidden = false
                            self.timer.invalidate()
                            Firestore.firestore().collection("Battle").document(documentID).updateData(["winner":OPPONENT_USER])
                        }
                    }
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
                
                if let deck = value["deck"] {
                    
                    self.myDeck = []
                    for name in deck as! [String]{
                        if allCard.filter({$0.name == name}).first != nil {
                            
                            self.myDeck.append(allCard.filter{$0.name == name}.first!)
                        }
                    }
                    
                    self.deckCountLabel.text = "\(self.myDeck.count)"
                }
                
                if let cards = value["cards"] {
                    var newCards = [Card]()
                    for name in cards as! [String]{
                        newCards.append(allCard.filter{$0.name == name}.first ?? Card(name: "스파크", price: 3, usePrice: 1, count: 20, effect: "상대에게 피해를 2 준다.",magicAttribute:Magic.번개.rawValue,gem: nil,image:"스파크"))
                    }
                    self.myCards = newCards
                }
                if let trash = value["trash"] {
                    for name in trash as! [String] {
                        self.myTrash.append(allCard.filter{$0.name == name}.first!)
                    }
                    
                    self.trashCardLabel.text = "\(self.myTrash.count)"
                }
            }
        })
        
        ref.child("battle").child(OPPONENT_USER).observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                
                let value = snapshot.value as! [String : AnyObject]
                
                self.enemyHPLabel.text = "\(value["HP"] as? Int ?? 0)"
                self.enemyMPLabel.text = "\(value["MP"] as? Int ?? 0)"
                
                if let hp = value["HP"] {
                    
                    if (hp as! Int) <= 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.victoryOrDefeatImage.image = #imageLiteral(resourceName: "victory")
                            self.victoryOrDefeatImage.isHidden = false
                            self.timer.invalidate()
                            Firestore.firestore().collection("Battle").document(documentID).updateData(["winner":CURRENT_USER])
                        }
                    }
                }
                if value["useCard"] != nil {
                    var useCard = "\(value["useCard"]!)"
                    useCard.removeLast()
                    let card = allCard.filter({$0.name == useCard}).first
                    if card != nil && "\(value["useCard"]!)" != self.useCardString {
                        self.useCardString = "\(value["useCard"]!)"
                        self.showCard(card: card!)
                    }
                }
                
                if let deck = value["deck"] {
                    
                    self.enemyDeck = []
                    for name in deck as! [String] {
                        if allCard.filter({$0.name == name}).first != nil {
                            self.enemyDeck.append(allCard.filter{$0.name == name}.first!)
                        }
                    }
                    
                    self.enemyDeckLabel.text = "\(self.enemyDeck.count)"
                }
                
                if let cards = value["cards"] {
                    var newCards = [Card]()
                    
                    for name in cards as! [String]{
                        if allCard.filter({$0.name == name}).first != nil {
                            newCards.append(allCard.filter{$0.name == name}.first!)
                        }
                    }
                    
                    self.enemyCards = newCards
                }
                if let trash = value["trash"] {
                    for name in trash as! [String]{
                        if allCard.filter({$0.name == name}).first != nil {
                            self.enemyTrash.append(allCard.filter{$0.name == name}.first!)
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func tapEndTurnButton(_ sender: Any) {
        collectionRef.document(documentID).updateData(["turn":OPPONENT_USER])
        Firestore.firestore().collection("Battle").document(documentID).collection("Turn").addDocument(data: ["player":CURRENT_USER, "turnTime":seconds,"HP":myHPLabel.text ?? "","MP":myMPLabel.text ?? ""])
    }
    
    func setDatabase() {
        let turn = CURRENT_USER == "fomagran" ? true:false
        var newCards = [String]()
        for _ in 0...7 {
            newCards.append(allCard.randomElement()?.name ?? "스파크")
        }
        ref.child("battle").child(CURRENT_USER).setValue(["HP":20,"MP":30,"cards":newCards,"turn":turn,"trash":[],"deck":[]])
    }
    
    @objc func tapBackground() {

        if victoryOrDefeatImage.isHidden == false {
            self.ref.removeValue()
            self.performSegue(withIdentifier: "unwindMainViewController", sender: nil)
        }
    }
    
    @IBAction func tapSupplierButton(_ sender: Any) {
        isSupplier = true
        performSegue(withIdentifier: "showSupplierViewController", sender: nil)
    }
    
    @IBAction func tapCardButton(_ sender: Any) {
        isSupplier = false
        performSegue(withIdentifier: "showSupplierViewController", sender: nil)
    }
    
    
    func configure() {
        victoryOrDefeatImage.isHidden = true
        myDeck = []
        deckCountLabel.text = "\(myDeck.count)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSupplierViewController" {
            let vc = segue.destination as! SupplierViewController
            vc.myCards = myCards
            vc.isSupplier = isSupplier
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
            vc.showCardImage = UIImage(named: useCard?.image ?? "스파크")
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

        let soundintro = Bundle.main.path(forResource: soundName, ofType: "mp3") ?? "화염구"
        do {
            if let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundintro)) {
                soundIntroPlayer = player
            }
                    
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
    func didDissmiss(magic:String) {
        
        var imageView:UIImageView = UIImageView()
        
        switch magic {
        case Magic.무속성.rawValue:
            imageView =  UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), resourceName: "무_샘플")!
            playSound(soundName: "금지된마법")
        case Magic.물.rawValue:
            imageView =  UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), resourceName: "물_샘플")!
            playSound(soundName: "물의감옥")
        case Magic.불.rawValue:
            imageView = UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), resourceName: "불_샘플")!
            playSound(soundName: "화염구")
        case Magic.빛.rawValue:
            imageView = UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), resourceName: "성_회복")!
            playSound(soundName: "라파엘")
        case Magic.번개.rawValue:
            imageView = UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), resourceName: "번개_샘플")!
            playSound(soundName: "낙뢰")
        default:
            imageView = UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), resourceName: "암_샘플")!
            playSound(soundName: "릴림")
        }

        
        enemyCharacter.image = UIImage(named: "Character_Sick.png")
        enemyCharacter.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.startAnimating()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo:view.centerXAnchor)
                  .isActive = true
        imageView.centerYAnchor.constraint(equalTo:view.centerYAnchor)
                  .isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height)
                  .isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width)
                  .isActive = true
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            imageView.isHidden = true
            self.enemyCharacter.image = UIImage(named: "캐릭터.png")
            self.enemyCharacter.contentMode = .scaleAspectFit
        }
    }
}
