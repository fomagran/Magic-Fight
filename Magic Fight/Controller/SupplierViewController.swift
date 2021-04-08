//
//  SupplierViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/08.
//

import UIKit

class SupplierViewController: UIViewController {

    @IBOutlet weak var bigCardDescriptionLabel: UILabel!
    @IBOutlet weak var bigCard: UIImageView!
    @IBOutlet weak var bigCardLabel: UILabel!
    @IBOutlet weak var bigCardBackground: UIImageView!
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tapGesture.delegate = self
        
    }
    @IBAction func tapBuyButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configure() {
        bigCard.isHidden = true
        bigCardLabel.isHidden = true
        bigCardBackground.isHidden = true
        bigCardDescriptionLabel.isHidden = true
        buyButton.isHidden = true
    }
    @IBAction func tapBackGround(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SupplierViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allCard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "SupplierCollectionViewCell", for: indexPath) as! SupplierCollectionViewCell
        cell.label.text = allCard[indexPath.item].name
        return cell
    }
    
    
}

extension SupplierViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collection.cellForItem(at: indexPath) as! SupplierCollectionViewCell
        bigCardLabel.text = cell.label.text
        bigCardDescriptionLabel.text = allCard[indexPath.item].effect
        
        bigCard.isHidden = false
        bigCardLabel.isHidden = false
        bigCardBackground.isHidden = false
        bigCardDescriptionLabel.isHidden = false
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


