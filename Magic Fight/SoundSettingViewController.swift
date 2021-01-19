//
//  SoundSettingViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class SoundSettingViewController: UIViewController {


    @IBOutlet weak var xbutton: UIButton!
    @IBOutlet weak var gameOverButton: UIButton!
    @IBOutlet weak var effectSoundSlider: UISlider!
    @IBOutlet weak var effectSoundLabel: UILabel!
    @IBOutlet weak var backgroundSoundSlider: UISlider!
    @IBOutlet weak var backgroundSoundLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func handleXButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
