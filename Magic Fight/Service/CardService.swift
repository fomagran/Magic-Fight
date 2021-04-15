//
//  CardService.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/15.
//

import Foundation
import FirebaseDatabase

class CardService {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    static func cardEffect(value:String) {
        switch value {
        case "스파크":
            print("스파크")
        case "에너지 재생":
            print("에너지 재생")
        default:
            print("디폴트")
        }
    }
    
}
