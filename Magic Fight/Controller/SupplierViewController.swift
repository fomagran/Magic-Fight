//
//  SupplierViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/08.
//

import UIKit
import FirebaseDatabase

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
    var myMP = 0
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
        
            if isLowMagic {
                myCards.append(currentCard!)
                ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":myCards.map{$0.name}])
                lowMagicCardCount += 1
                if lowMagicCardCount == 4 {
                    dismiss(animated: true, completion: nil)
                }
            }else {
                cardEffect(name: currentCard!.name)
                if !isLowMagic {
                    dismiss(animated: true, completion: nil)
                }
            }

        delegate?.didDismiss(card: currentCard!)
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
            let newCards = myCards + ["푸른젬","푸른젬","푸른젬","푸른젬","푸른젬"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards ])
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
            let newCards = myCards + ["붉은젬"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards ])
            print(name)
        case "불의순환":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards + ["불의순환"]
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
            let newCards = myCards + ["방전"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "방점":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 8])
            let newCards = myCards + ["축전"]
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
        case "헌납":
            var index = -1
            var name = ""
            for (i,d) in myDeck.enumerated() {
                if d.name.contains("젬") {
                    index = i
                    name = d.name
                }
            }
            if index != -1 {
                myDeck.remove(at: index)
            }
            var hp = 0
            if name == "푸른젬" {
                hp = 1
            }else if name == "붉은젬" {
                hp = 3
            }else if name == "황금젬" {
                hp = 6
            }else {
                hp = 10
            }
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + hp])
        case "폭주":
            print(name)
        case "천사의깃털":
            let newCards = myCards + ["불의 순환"] //랜덤으로 바뀌어야함
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "최면":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["deck":enemyDeck + ["악몽","악몽"]])
        case "암시":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["deck":myDeck + ["악몽"]])
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["deck":enemyDeck + ["악몽"]])
        case "악몽":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP - 1])
        case "폭발의진":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 12])
        case "초급마법서":
            configure()
            isLowMagic = true
            isSupplier = true
            allCard = allCard.filter{$0.price < 5}
            collection.reloadData()
        case "마법지팡이":
            print(name)
        case "도둑":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + enemyHP])
        case "금광":
            let newCards = myCards + ["황금젬"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "보석세공사":
            print(name)
        case "사기꾼":
            print(name)
        case "기도":
            //1장 뽑기도 해야함
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 1])
        case "성수":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 3])
        case "마나물약":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + 3])
        case "선물상자":
            print(name)
        case "위조기술자":
            print(name)
        case "불잉걸":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards + ["화염구"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "수증기응결":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards + ["물대포"]
            ref.child("battle").child(CURRENT_USER).updateChildValues(["cards":newCards])
        case "먹구름":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
            let newCards = myCards + ["낙뢰"]
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



