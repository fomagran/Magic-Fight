//
//  Constants.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/15.
//

import Foundation
import FirebaseDatabase

let CURRENT_USER = UserDefaults.standard.string(forKey: "nickname")!
let OPPONENT_USER = CURRENT_USER == "fomagran" ? "acop" : "fomagran"
let PLAYER_NUMBER = CURRENT_USER == "fomagran" ? "1" : "2"

var ref = Database.database().reference()
