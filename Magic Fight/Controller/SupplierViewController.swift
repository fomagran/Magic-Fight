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
    var cards:[Card] = []
    var isBeginnerMagic:Bool = false
    var isGiftBox:Bool = false
    var trash:[Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tapGesture.delegate = self
        
        
    }
    @IBAction func tapBuyButton(_ sender: Any) {
        
        if currentCard?.name == "선물상자" {
            setGiftBox()
            return
        }
        
        if currentCard?.name == "초급마법서" {
            setBeginnerMagic()
            return
        }
        
        if isGiftBox {
            collectionRef.document(documentID).collection(OPPONENT_USER).document(OPPONENT_USER).collection("Deck").addDocument(data: currentCard.toDictionary!)
            dismiss(animated: true, completion: nil)
            return
        }
        
        if isBeginnerMagic {
            MY_CARDS.append(currentCard!)
            dismiss(animated: true, completion: nil)
            return
        }
        
        if !isSupplier {
            if myMP < currentCard!.price {
                showAlert(str: "젬이 부족해 카드를 사용할 수 없습니다.")
            }else{
                let index = MY_CARDS.firstIndex{$0.name == "\(currentCard!.name)"}!
                MY_CARDS.remove(at: index)
                collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":myMP-currentCard!.usePrice])
                collectionRef.document(documentID).updateData(["\(CURRENT_USER)useCard":"\(currentCard!.name)"])
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Trash").addDocument(data: currentCard!.toDictionary!)
                cardEffect(name: currentCard!.name)
                recordRef.document(recordDocument).collection("Turn").document(turnLastDocument).collection("UsedCard").addDocument(data: ["player":CURRENT_USER, "card":currentCard?.name ?? "","attribute":currentCard?.magicAttribute ?? "","price":currentCard?.usePrice ?? 0])
                dismiss(animated: true, completion: nil)
            }
        }else {
            if myMP < currentCard!.price {
                showAlert(str: "젬이 부족해 살 수 없습니다.")
            }else {
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").addDocument(data: currentCard!.toDictionary!)
                collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":FieldValue.increment(-Int64(currentCard?.price ?? 0))])
                recordRef.document(recordDocument).collection("Turn").document(turnLastDocument).collection("BoughtCard").addDocument(data: ["player":CURRENT_USER, "card":currentCard?.name ?? "","price":currentCard?.price ?? 0])
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
    
    func setGiftBox() {
        MY_CARDS.remove(at:MY_CARDS.firstIndex{$0.name == "선물상자"}!)
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":myMP-2])
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)useCard":"선물상자"])
        recordRef.document(recordDocument).collection("Turn").document(turnLastDocument).collection("UsedCard").addDocument(data: ["player":CURRENT_USER, "card":"선물상자","attribute":"무속성","price":선물상자.usePrice])
        collection.reloadData()
        isGiftBox = true
    }
    
    func setBeginnerMagic() {
        isSupplier = true
        cards = allCard.filter{ 1...4 ~= $0.price}
        isBeginnerMagic = true
        currentCard = nil
        bigCard.isHidden = true
        MY_CARDS.remove(at:MY_CARDS.firstIndex{$0.name == "초급마법서"}!)
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":myMP-1])
        collectionRef.document(documentID).updateData(["\(CURRENT_USER)useCard":"초급마법서"])
        recordRef.document(recordDocument).collection("Turn").document(turnLastDocument).collection("UsedCard").addDocument(data: ["player":CURRENT_USER, "card":"초급마법서","attribute":"무속성","price":초급마법서.usePrice])
        collection.reloadData()
    }
    
    func addDeckAndTrash() {
        collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Trash").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                let card = Card(dictionary: document.data(), documentID: document.documentID)
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Trash").document(document.documentID).delete()
                collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").addDocument(data:card.toDictionary!)
            }
        }
    }
    
    @IBAction func tapBackGround(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SupplierViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "SupplierCollectionViewCell", for: indexPath) as! SupplierCollectionViewCell
        cell.image.image = UIImage(named: cards[indexPath.row].image)
        return cell
    }
    
    func cardEffect(name:String){
        switch name {
        case "스파크":
            collectionRef.document(documentID).updateData(["\(OPPONENT_USER)HP":enemyHP - 2])
        case "에너지재생":
            collectionRef.document(documentID).updateData(["\(CURRENT_USER)HP":myHP + 4])
        case "화염구":
            collectionRef.document(documentID).updateData(["\(OPPONENT_USER)HP":enemyHP - 5])
        case "물대포":
            collectionRef.document(documentID).updateData(["\(OPPONENT_USER)HP":enemyHP - 5])
        case "낙뢰":
            collectionRef.document(documentID).updateData(["\(OPPONENT_USER)HP":enemyHP - 5])
        case "재충전":
            collectionRef.document(documentID).updateData(["\(CURRENT_USER)HP":myHP + 2])
        case "암흑광선":
            collectionRef.document(documentID).updateData(["\(OPPONENT_USER)HP":enemyHP - 5])
            collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    if document.get("gem") != nil {
                        collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").document(document.documentID).delete()
                    }
                }
            }
        case "수혈":
            collectionRef.document(documentID).updateData(["\(OPPONENT_USER)HP":enemyHP - 3])
            collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").addDocument(data: 붉은젬.toDictionary!)
        case "정신집중":
            collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return }
                if snapshot.documents.count < 3 {
                    self.addDeckAndTrash()
                    collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").getDocuments { snapshot, error in
                        guard let snapshot = snapshot else { return }
                        for i in 0..<3 {
                            let card = Card(dictionary: snapshot.documents[i].data(), documentID: snapshot.documents[i].documentID)
                            collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":FieldValue.increment(Int64(card.gem ?? 0))])
                            MY_CARDS.append(card)
                        }
                    }
                }else {
                    for document in snapshot.documents {
                        let card = Card(dictionary: document.data(), documentID: document.documentID)
                        collectionRef.document(documentID).updateData(["\(CURRENT_USER)MP":FieldValue.increment(Int64(card.gem ?? 0))])
                        MY_CARDS.append(card)
                    }
                }
            }
        case "최면":
            collectionRef.document(documentID).collection(OPPONENT_USER).document(OPPONENT_USER).collection("Deck").addDocument(data: 악몽.toDictionary!)
            collectionRef.document(documentID).collection(OPPONENT_USER).document(OPPONENT_USER).collection("Deck").addDocument(data: 악몽.toDictionary!)
        case "암시":
            collectionRef.document(documentID).collection(CURRENT_USER).document(CURRENT_USER).collection("Deck").addDocument(data: 악몽.toDictionary!)
            collectionRef.document(documentID).collection(OPPONENT_USER).document(OPPONENT_USER).collection("Deck").addDocument(data: 악몽.toDictionary!)
        case "악몽":
            collectionRef.document(documentID).updateData(["\(CURRENT_USER)HP":myHP - 1])
        case "성수":
            collectionRef.document(documentID).updateData(["\(CURRENT_USER)HP":myHP + 3])
            
            
        case "정신과부하":
            let newMP = myMP + 5
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":newMP ])
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
        case "불의순환":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
 
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

        case "방전":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 8])
   
        case "폭발의진":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 12])
        case "마법지팡이":
            let randomCard1 = allCard.randomElement()?.name ?? ""
            let randomCard2 = allCard.randomElement()?.name ?? ""
          
        case "도둑":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + enemyMP])
        case "금광":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + 6])
        case "보석세공사":
            let gem = [1,3,6,10].randomElement() ?? 0
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + gem])
        case "기도":
            let randomCard = allCard.randomElement()?.name ?? ""
  
            ref.child("battle").child(CURRENT_USER).updateChildValues(["HP":myHP + 1])
        case "마나물약":
            ref.child("battle").child(CURRENT_USER).updateChildValues(["MP":myMP + 3])
        case "불잉걸":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])
         
        case "수증기응결":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])

        case "먹구름":
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 1])

        default:
            print(name)
        }
    }    
}

extension SupplierViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentCard = cards[indexPath.item]
        bigCard.image = UIImage(named:cards[indexPath.row].image)
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



