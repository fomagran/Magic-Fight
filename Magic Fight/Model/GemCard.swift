//
//  GemCard.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import Foundation

struct GemCard {
    let name:String
    let price:Int
    let gem:Int
    let count:Int
    
    init(name:String,price:Int,gem:Int,count:Int) {
        self.name = name
        self.price = price
        self.gem = gem
        self.count = count
    }
}

let allGemCard:[GemCard] = [
    GemCard(name: "푸른 젬", price: 1, gem: 1, count: 30),
    GemCard(name: "붉은 젬", price: 3, gem: 2, count: 30),
    GemCard(name: "황금 젬", price: 6, gem: 4, count: 30),
    GemCard(name: "칠흑의 젬", price: 10, gem: 5, count: 20)
    
]
