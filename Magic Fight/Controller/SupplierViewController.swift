//
//  SupplierViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/08.
//

import UIKit
import FirebaseDatabase

class SupplierViewController: UIViewController {

    @IBOutlet weak var bigCard: UIImageView!
    @IBOutlet weak var bigCardBackground: UIImageView!
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var cards:[Card]?
    var isSupplier:Bool = true
    var ref = Database.database().reference()
    var myHP = 0
    var enemyHP = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tapGesture.delegate = self
        
    }
    @IBAction func tapBuyButton(_ sender: Any) {
        if !isSupplier {
            ref.child("battle").child(OPPONENT_USER).updateChildValues(["HP":enemyHP - 5])
        }
        dismiss(animated: true, completion: nil)
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
        return cards == nil ? allCard.count : cards!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "SupplierCollectionViewCell", for: indexPath) as! SupplierCollectionViewCell
        cell.image.image = cards == nil ? allCard[indexPath.row].image : cards![indexPath.row].image
        return cell
    }
    
    
}

extension SupplierViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        bigCard.image = cards == nil ? allCard[indexPath.item].image : cards![indexPath.item].image
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



