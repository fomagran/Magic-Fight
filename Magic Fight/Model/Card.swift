//
//  Card.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import Foundation

struct Card :Equatable{
    let name:String
    let price:Int
    let usePrice:Int
    let count:Int
    let effect:String
    let magicAttribute:Magic
    let gem:Int?
    
    
    init(name:String,price:Int,usePrice:Int,count:Int,effect:String,magicAttribute:Magic,gem:Int?) {
        self.name = name
        self.price = price
        self.usePrice = usePrice
        self.count = count
        self.effect = effect
        self.magicAttribute = magicAttribute
        self.gem = gem
    }
}


enum Magic {
    case 암흑
    case 번개
    case 빛
    case 물
    case 불
    case 무속성
}

var allCard:[Card] = [
    Card(name: "금지된 마법", price: 20, usePrice: 20, count: 1, effect: "게임에서 승리한다.",magicAttribute:.암흑,gem: nil),
    Card(name: "스파크", price: 3, usePrice: 1, count: 20, effect: "상대에게 피해를 2 준다.",magicAttribute:.번개,gem: nil),
    Card(name: "에너지 재생", price: 4, usePrice: 2, count: 10, effect: "체력을 4 회복한다.",magicAttribute:.빛,gem: nil),
    Card(name: "정신 과부하", price: 5, usePrice: 1, count: 8, effect: "푸른 젬 5개를 공급처에서 내 손으로 가져온다.",magicAttribute:.암흑,gem: nil),
    Card(name: "화염구", price: 4, usePrice: 5, count: 20, effect: "상대에게 피해를 5 준다.",magicAttribute:.불,gem: nil),
    Card(name: "물대포", price: 4, usePrice: 5, count:20, effect: "상대에게 피해를 5 준다.",magicAttribute:.물,gem: nil),
    Card(name: "낙뢰", price: 4, usePrice: 5, count: 20, effect: "상대에게 피해를 5 준다.",magicAttribute:.번개,gem: nil),
    Card(name: "물벼락", price: 6, usePrice: 5, count: 4, effect: "상대에게 피해를 7 준다.",magicAttribute:.물,gem: nil),
    Card(name: "물의 감옥", price: 6, usePrice: 7, count: 4, effect: "상대 손패의 카드 3장을 무작위로 버린다.",magicAttribute:.물,gem: nil),
    Card(name: "신성한 불꽃", price: 8, usePrice: 6, count: 10, effect: "상대에게 피해를 4 주고, 체력을 4 회복한다.",magicAttribute:.불,gem: nil),
    Card(name: "물의 순환", price: 8, usePrice: 1, count: 4, effect: "체력을 2 회복한다.",magicAttribute:.번개,gem: nil),
    Card(name: "수혈", price: 5, usePrice: 5, count: 10, effect: "상대에게 피해를 3 주고, 공급처에서 붉은 젬을 한 장 가져온다.",magicAttribute:.물,gem: nil),
    Card(name: "불의 순환", price: 8, usePrice: 1, count: 4, effect: "상대에게 피해를 1 주고, 카드를 한 장 뽑고, 공급처에서 불의 순환 카드를 한 장 가져온다.",magicAttribute:.불,gem: nil),
    Card(name: "도깨비불", price: 6, usePrice: 5, count: 10, effect: "상대에게 피해를 3 주고, 상대의 젬 에너지를 1 깎는다.",magicAttribute:.불,gem: nil),
    Card(name: "소환의 진", price: 10, usePrice: 8, count: 8, effect: "악마 또는 천사 카드 한 장을 무작위로 가져온다.",magicAttribute:.무속성,gem: nil),
    Card(name: "서큐버스", price: 0, usePrice: 4, count: 0, effect: "상대에게 피해를 5 주고, 내 체력을 5 회복한다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil),
    Card(name: "사타나치아", price: 0, usePrice: 3, count: 0, effect: "상대에게 내 젬 에너지만큼의 피해를 준다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil),
    Card(name: "아스타로트", price: 0, usePrice: 3, count: 0, effect: "상대의 젬 에너지를 5 깎는다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil),
    Card(name: "금지된 마법", price: 20, usePrice: 20, count: 1, effect: "게임에서 승리한다.",magicAttribute:.암흑,gem: nil),
    Card(name: "릴림", price: 0, usePrice: 5, count: 0, effect: "체력을 10 회복한다. 최대 체력을 넘어 회복했을 경우 그 초과분만큼 상대에게 피해를 준다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil),
    Card(name: "미카엘", price: 0, usePrice: 4, count: 0, effect: "내 젬 에너지만큼 회복한다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil),
    Card(name: "우리엘", price: 0, usePrice: 1, count: 0, effect: "상대에게 피해를 5 주고, 내 체력을 5 회복한다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil),
    Card(name: "가브리엘", price: 0, usePrice: 4, count: 0, effect: "체력을 10 회복한다. 최대 체력을 넘어 회복했을 경우 그 초과분만큼 상대에게 피해를 준다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil),
    Card(name: "라파엘", price: 0, usePrice: 4, count: 0, effect: "젬 에너지를 5 늘린다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil),
    Card(name: "축전", price: 5, usePrice: 1, count: 10, effect: "자신에게 피해를 4 주고, 이 카드를 파괴하고, 방전 카드를 가져온다.",magicAttribute:.번개,gem: nil),
    Card(name: "방전", price: 0, usePrice: 4, count: 0, effect: "상대에게 피해를 8 주고, 이 카드를 파괴하고, 축전 카드를 가져온다.",magicAttribute:.번개,gem: nil),
    Card(name: "암흑광선", price: 5, usePrice: 4, count: 10, effect: "상대에게 피해를 5 주고, 내 덱의 무작위 젬을 하나 파괴한다.",magicAttribute:.암흑,gem: nil),
    Card(name: "헌납", price: 4, usePrice: 2, count: 8, effect: "내 덱의 무작위 젬을 하나 파괴하고, 그 젬 에너지의 두 배만큼 체력을 회복한다.",magicAttribute:.빛,gem: nil),
    Card(name: "폭주", price: 8, usePrice: 4, count: 4, effect: "덱에서 카드를 3장 뽑는다. 이때 가격이 3 이하인 카드들은 파괴된다.",magicAttribute:.암흑,gem: nil),
    Card(name: "천사의 깃털", price: 10, usePrice: 8, count: 4, effect: "무작위 주문을 하나 얻어 손으로 가져온다.",magicAttribute:.빛,gem: nil),
    Card(name: "최면", price: 8, usePrice: 5, count: 4, effect: "상대의 덱에 악몽 카드를 두 장 섞어 넣는다.",magicAttribute:.암흑,gem: nil),
    Card(name: "암시", price: 4, usePrice: 3, count: 10, effect: "상대와 자신의 덱에 악몽 카드를 한 장씩 섞어 넣는다.",magicAttribute:.암흑,gem: nil),
    Card(name: "악몽", price: 0, usePrice: 1, count: 1, effect: "자신에게 피해를 1 준다. 구매할 수 없으며, 사용 후 파괴된다.",magicAttribute:.암흑,gem: nil),
    Card(name: "폭발의 진", price: 10, usePrice: 10, count: 8, effect: "상대에게 피해를 12 준다.",magicAttribute:.불,gem: nil),
    Card(name: "초급 마법서", price: 0, usePrice: 1, count: 0, effect: "가격 4 이하의 주문 카드 하나를 공급처에서 선택하여 가져온다. 게임을 시작할 때만 얻을 수 있으며, 구매할 수 없고, 사용 후 파괴된다.",magicAttribute:.무속성,gem: nil),
    Card(name: "가마솥", price: 5, usePrice: 2, count: 10, effect: "내 손패의 카드 한 장을 파괴하고, 그 카드보다 가격이 1 높은 카드 한 장을 공급처에서 선택하여 가져온다.", magicAttribute: .무속성,gem: nil),
    Card(name: "도둑", price: 8, usePrice: 5, count: 8, effect: "상대의 젬 에너지만큼 내 젬 에너지를 늘린다.", magicAttribute: .암흑,gem: nil),
    Card(name: "마법 지팡이", price: 5, usePrice: 2, count: 8, effect: "카드를 두 장 뽑는다.", magicAttribute: .무속성,gem: nil),
    Card(name: "금광", price: 8, usePrice: 2, count: 8, effect: "황금 젬 카드 한 장을 공급처에서 가져온다", magicAttribute: .무속성,gem: nil),
    Card(name: "보석 세공사", price: 8, usePrice: 5, count: 8, effect: "내 손패의 젬 카드 하나를 파괴하고, 그 상위 단계의 젬을 손으로 가져온다.", magicAttribute: .무속성,gem: nil),
    Card(name: "사기꾼", price: 5, usePrice: 5, count: 4, effect: "상대 덱에서 카드를 한 장 뽑는다.", magicAttribute: .암흑,gem: nil),
    Card(name: "기도", price: 4, usePrice: 2, count: 20, effect: "체력을 1 회복하고, 카드를 한 장 뽑는다.", magicAttribute: .빛,gem: nil),
    Card(name: "성수", price: 2, usePrice: 3, count: 10, effect: "체력을 3 회복한다.", magicAttribute: .빛,gem: nil),
    Card(name: "마나 물약", price: 3, usePrice: 5, count: 10, effect: "잼 에너지를 4 늘리고, 카드를 한 장 뽑는다.", magicAttribute: .빛,gem: nil),
    Card(name: "선물 상자", price: 1, usePrice: 2, count: 10, effect: "내 손패의 카드 한 장을 선택한다. 상대가 그 카드를 가져온다.", magicAttribute: .무속성,gem: nil),
    Card(name:"위조 기술자", price: 3, usePrice: 3, count: 10, effect: "상대가 카드를 한 장 뽑는다. 그 카드가 젬 카드일 경우, 그 카드를 두 장 복사하여 내 손으로 가져온다.", magicAttribute: .무속성,gem: nil),
    Card(name: "불잉걸", price: 6, usePrice: 4, count: 10, effect: "상대에게 피해를 1 주고, 화염구 카드 한 장을 가져온다.", magicAttribute: .불,gem: nil),
    Card(name: "수증기 응결", price: 6, usePrice: 4, count: 10, effect: "상대에게 피해를 1 주고, 화염구 카드 한 장을 가져온다.", magicAttribute: .물,gem: nil),
    Card(name: "먹구름", price: 6, usePrice: 4, count: 10, effect: "상대에게 피해를 1 주고, 낙뢰 카드 한 장을 가져온다.", magicAttribute: .번개,gem: nil),
    Card(name: "푸른 젬", price: 1,usePrice: 0, count: 30, effect: "",magicAttribute:.무속성 ,gem:1),
    Card(name: "붉은 젬", price: 3,usePrice: 0, count: 30, effect: "",magicAttribute:.무속성 ,gem:3),
    Card(name: "황금 젬", price: 6, usePrice: 0,count: 30, effect: "",magicAttribute:.무속성 ,gem:6),
    Card(name: "칠흑의 젬", price: 10, usePrice: 0,count: 20, effect: "",magicAttribute:.무속성 ,gem:10)
]
