//
//  SupplierViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/08.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

protocol SupplierViewControllerDelegate:AnyObject {
    func didDismiss(card:Card)
}

class SupplierViewController: UIViewController {

    @IBOutlet weak var bigCard: UIImageView!
    @IBOutlet weak var bigCardBackground: UIImageView!
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    weak var delegate:SupplierViewControllerDelegate?
    var currentCard:Card?
    var myCards:[Card] = []
    var enemyCards:[Card] = []
    var isSupplier:Bool = true
    var myHP = 0
    var myTrash = [Card]()
    var enemyTrash = [Card]()
    var enemyHP = 0
    var myMP:Int!
    var enemyMP = 0
    var myDeck = [Card]()
    var enemyDeck = [Card]()
    var isLowMagic:Bool = false
    var lowMagicCardCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tapGesture.delegate = self
        
    }
    @IBAction func tapBuyButton(_ sender: Any) {
        
        if !isSupplier {
            if myMP < currentCard!.price {
                showAlert(str: "젬이 부족해 카드를 사용할 수 없습니다.")
            }else{
            var newCards = myCards.map{$0.name}
            let index = myCards.firstIndex(of: currentCard!)!
            newCards.remove(at: index)
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP - currentCard!.usePrice])
            ref.child("battle").child(CURRENT_USER).updateChildValues(["useCard":"\(currentCard!.name)\(PLAYER_NUMBER)"])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["useCard":"\(currentCard!.name)\(PLAYER_NUMBER)"])
            cardEffect(name: currentCard!.name)
                Firestore.firestore().collection("Battle").document(documentID).collection("UsedCard").addDocument(data: ["player":CURRENT_USER, "card":currentCard?.name ?? "","attribute":currentCard?.magicAttribute.rawValue ?? ""])
            dismiss(animated: true, completion: nil)
            }
        }else {
            if myMP < currentCard!.price {
                showAlert(str: "젬이 부족해 살 수 없습니다.")
            }else {
                var newCards = myCards.map{$0.name}
                newCards.append(currentCard!.name)
                ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
                let newMP = myMP - currentCard!.price
                ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":newMP])
                Firestore.firestore().collection("Battle").document(documentID).collection("BoughtCard").addDocument(data: ["player":CURRENT_USER, "card":currentCard?.name ?? ""])
                dismiss(animated: true, completion: nil)
            }
        }
    }

    func showAlert(str:String) {
        let alert = UIAlertController(title: "불가", message: str, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func configure() {
        bigCard.isHidden = true
        bigCardBackground.isHidden = true
        buyButton.isHidden = true
        if isSupplier == false {
            buyButton.setTitle("Use this card", for: .normal)
        }
    }
    @IBAction func tapBackGround(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SupplierViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSupplier ? allCard.count : myCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "SupplierCollectionViewCell", for: indexPath) as! SupplierCollectionViewCell
        cell.image.image = isSupplier ? allCard[indexPath.row].image : myCards[indexPath.row].image
        return cell
    }
    
    
    func cardEffect(name:String){
        switch name {
        case "스파크":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 2])
        case "에너지재생":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 4])
        case "정신과부하":
            let newMP = myMP + 5
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":newMP ])
        case "화염구":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
        case "물대포":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
        case "낙뢰":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
        case "물벼락":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
        case "물의감옥":
            if enemyCards.count > 3 {
                enemyCards.remove(at: 0)
                enemyCards.remove(at: 1)
                enemyCards.remove(at: 2)
            }else {
                enemyCards.removeAll()
            }
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["cards": enemyCards])
        case "신성한불꽃":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 4])
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 4])
        case "물의순환":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 2])
        case "수혈":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 3])
            let newMP = myMP + 3
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":newMP])
        case "불의순환":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards.map{$0.name} + ["불의순환"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "도깨비불":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["MP":enemyMP - 1])
        case "서큐버스":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 5])
        case "사타나치아":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - myHP])
        case "아스타로트":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyMP - 5])
        case "금지된마법":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":0])
        case "릴림":
            var damage = 0
            if myHP + 10 > 20 {
               damage = myHP + 10 - 20
            }
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 10])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - damage])
        case "미카엘":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + myMP])
        case "우리엘":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 5])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
        case "가브리엘":
            var damage = 0
            if myHP + 10 > 20 {
               damage = myHP + 10 - 20
            }
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 10])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - damage])
        case "라파엘":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + 5])
        case "축전":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP - 5])
            let newCards = myCards.map{$0.name} + ["방전"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "방전":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 8])
            let newCards = myCards.map{$0.name} + ["축전"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "암흑광선":
            var index = -1
            for (i,d) in myDeck.enumerated() {
                if d.name.contains("젬") {
                    index = i
                }
            }
            if index != -1 {
                myDeck.remove(at: index)
            }
            ref.child("battle").child(CURRENT_USER).updateChildValues(["deck":myDeck])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
        case "최면":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["deck":enemyDeck + ["악몽","악몽"]])
        case "암시":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["deck":myDeck + ["악몽"]])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["deck":enemyDeck + ["악몽"]])
        case "악몽":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP - 1])
        case "폭발의진":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 12])
        case "마법지팡이":
            let randomCard1 = allCard.randomElement()?.name ?? ""
            let randomCard2 = allCard.randomElement()?.name ?? ""
            let newCards = myCards.map{$0.name} + [randomCard1,randomCard2]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "도둑":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + enemyMP])
        case "금광":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + 6])
        case "보석세공사":
            let gem = [1,3,6,10].randomElement() ?? 0
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + gem])
        case "기도":
            let randomCard = allCard.randomElement()?.name ?? ""
            let newCards = myCards.map{$0.name} + [randomCard]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 1])
        case "성수":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 3])
        case "마나물약":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + 3])
        case "불잉걸":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards.map{$0.name} + ["화염구"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "수증기응결":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards.map{$0.name} + ["물대포"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "먹구름":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards.map{$0.name} + ["낙뢰"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        default:
            print(name)
        }
    }

    
    
}

extension SupplierViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        currentCard = isSupplier ? allCard[indexPath.item] : myCards[indexPath.item]
        bigCard.image = isSupplier ? allCard[indexPath.item].image : myCards[indexPath.item].image
        bigCard.isHidden = false
        bigCardBackground.isHidden = false
        buyButton.isHidden = false
    
    }
}

extension SupplierViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}


extension SupplierViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !self.collection.frame.contains(touch.location(in: self.view))
    }
    
}



