//
//  SupplierViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/01/19.
//

import UIKit

class SupplierViewController: UIViewController {

    @IBOutlet weak var price3: UILabel!
    @IBOutlet weak var price2: UILabel!
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapBackground(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
