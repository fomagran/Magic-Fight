//
//  GameViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gemPowerCount: UILabel!
    @IBOutlet weak var card5: UIButton!
    @IBOutlet weak var card4: UIButton!
    @IBOutlet weak var card3: UIButton!
    @IBOutlet weak var card2: UIButton!
    @IBOutlet weak var card1: UIButton!
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var discardCount: UILabel!
    @IBOutlet weak var leftCount: UILabel!
    @IBOutlet weak var myCount: UILabel!
    @IBOutlet weak var setting: UIButton!
    @IBOutlet weak var enemyCount: UILabel!
    @IBOutlet weak var attribute3: UIImageView!
    @IBOutlet weak var attribute2: UIImageView!
    @IBOutlet weak var attribute1: UIImageView!
    @IBOutlet weak var log: NSLayoutConstraint!
    @IBOutlet weak var supplierButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
