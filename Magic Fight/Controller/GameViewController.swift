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
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var magicAttributeImageView: UIImageView!
    @IBOutlet weak var myMPLabel: UILabel!
    @IBOutlet weak var myHPLabel: UILabel!
    @IBOutlet weak var enemyMPLabel: UILabel!
    @IBOutlet weak var enemyHPLabel: UILabel!
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
    var listener:ListenerRegistration?
    
    var isMyTurn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        observeUserInfo()
        start()
        drawFiveCardFromDeck()
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tapBackground))
        bgImage.addGestureRecognizer(tap1)
        bgImage.isUserInteractionEnabled = true
        
    }
    
    func observeUserInfo() {
        listener = collectionRef.document(documentID).addSnapshotListener { snapshot, error in
        
            turnLastDocument = snapshot?.get("turnLastDocument") as? String ?? ""
           
            self.myHPLabel.text =  "\(snapshot?.get("\(CURRENT_USER)HP") as? Int ?? 20)"
            if Int(self.myHPLabel.text ?? "0")! <= 0 {
                collectionRef.document(documentID).updateData(["win":OPPONENT_USER])
            }
            
            if let win = snapshot?.get("win") {
                if (win as? String ?? "") != CURRENT_USER  {
                    self.victoryOrDefeatImage.image = #imageLiteral(resourceName: "defeat")
                    self.victoryOrDefeatImage.isHidden = false
                    self.listener?.remove()
                }else {
                    self.victoryOrDefeatImage.image = #imageLiteral(resourceName: "victory")
                    self.victoryOrDefeatImage.isHidden = false
                    self.listener?.remove()
                }
            }
            self.myMPLabel.text =  "\(snapshot?.get("\(CURRENT_USER)MP") as? Int ?? 0)"
            self.enemyHPLabel.text =  "\(snapshot?.get("\(OPPONENT_USER)HP") as? Int ?? 0)"
            self.enemyMPLabel.text =  "\(snapshot?.get("\(OPPONENT_USER)MP") as? Int ?? 0)"
            if self.useCardString != "\(snapshot?.get("\(OPPONENT_USER)useCard") as? String ?? "")" {
                let name = "\(snapshot?.get("\(OPPONENT_USER)useCard") as? String ?? "")"
                let index = allCard.firstIndex{$0.name == name}!
                self.showCard(card: allCard[index])
            }
            self.useCardString = "\(snapshot?.get("\(OPPONENT_USER)useCard") as? String ?? "")"
            
            if (snapshot?.get("turn") as? String ?? "") == CURRENT_USER {
                self.setInitialState()
                self.start()
                self.timerLabel.backgroundColor = .clear
                self.setTurn(isMyturn: true)
                self.isMyTurn = true
            }else {
                self.timerLabel.backgroundColor = .red
                self.setTurn(isMyturn: false)
                self.timerLabel.text = "상대턴"
                self.timer.invalidate()
            }
        }
    }
    
    func configure() {
        victoryOrDefeatImage.isHidden = true
        myDeck = []
    }
    
    
    func endTurn() {
        for card in MY_CARDS {
            collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Trash").addDocument(data:card.toDictionary!)
        }
        isMyTurn = false
        MY_CARDS.removeAll()
//        recordRef.document(recordDocument).collection("Turn").document(turnLastDocument).updateData(["user":CURRENT_USER,"turnTime":timerLabel.text ?? ""])
//        let lastDocument = recordRef.document(recordDocument).collection("Turn").addDocument(data: ["timeStamp":FieldValue.serverTimestamp()]).documentID
//        collectionRef.document(documentID).updateData(["turnLastDocument":lastDocument])
        
    }
    
    func addDeckAndTrash() {
        collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Trash").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                let card = Card(dictionary: document.data(), documentID: document.documentID)
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Trash").document(document.documentID).delete()
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").addDocument(data:card.toDictionary!)
            }
            self.drawFiveCardFromDeck()
        }
    }
    
    func drawFiveCardFromDeck() {
        collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").getDocuments { snapshot,error in
            guard let snapshot = snapshot else { return }
            var cards = snapshot.documents.map{Card(dictionary: $0.data(), documentID: $0.documentID)}
            for _ in 0...4 {
                let index = (0..<cards.count).randomElement()!
                MY_CARDS.append(cards[index])
                collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":FieldValue.increment(Int64(cards[index].gem ?? 0))])
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").document(cards[index].documentID).delete()
                cards.remove(at: index)
            }
        }
    }
    
    @IBAction func tapEndTurnButton(_ sender: Any) {
        collectionRef.document(documentID).updateData(["turn":OPPONENT_USER])
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":0])
        endTurn()
        collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            if snapshot.documents.count < 5 {
                self.addDeckAndTrash()
            }else {
                self.drawFiveCardFromDeck()
            }
        }
    }
    
    @objc func tapBackground() {
        if victoryOrDefeatImage.isHidden == false {
            self.ref.removeValue()
            collectionRef.document(CURRENT_USER).delete()
            collectionRef.document(OPPONENT_USER).delete()
            MY_CARDS = []
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSupplierViewController" {
            let vc = segue.destination as! SupplierViewController
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
            vc.cards = isSupplier ? allCard.filter{$0.name != "초급마법서" } : MY_CARDS
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
                collectionRef.document(documentID).updateData(["turn":OPPONENT_USER])
                endTurn()
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").getDocuments { snapshot, error in
                    guard let snapshot = snapshot else { return }
                    if snapshot.documents.count < 5 {
                        self.addDeckAndTrash()
                    }else {
                        self.drawFiveCardFromDeck()
                    }
                }
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
