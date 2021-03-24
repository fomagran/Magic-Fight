//
//  DesignableSlider.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/03/24.
//

import UIKit

@IBDesignable
class DesignableSlider:UISlider {
    
    @IBInspectable var thumbImage:UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }
}
