//
//  Constants.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/15.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

let CURRENT_USER = UserDefaults.standard.string(forKey: "nickname")!
var OPPONENT_USER:String = ""
var PLAYER_NUMBER = "1"
var documentID:String = ""

var collectionRef = Firestore.firestore().collection("Battle")

var ref = Database.database().reference()
