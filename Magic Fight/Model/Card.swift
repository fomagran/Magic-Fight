//
//  Card.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/04/07.
//

import UIKit

struct Card :Equatable{
    let name:String
    let price:Int
    let usePrice:Int
    let count:Int
    let effect:String
    let magicAttribute:Magic
    let gem:Int?
    let image:UIImage
    
    init(name:String,price:Int,usePrice:Int,count:Int,effect:String,magicAttribute:Magic,gem:Int?,image:UIImage) {
        self.name = name
        self.price = price
        self.usePrice = usePrice
        self.count = count
        self.effect = effect
        self.magicAttribute = magicAttribute
        self.gem = gem
        self.image = image
    }
}

enum Magic:String {
    case 암흑
    case 번개
    case 빛
    case 물
    case 불
    case 무속성
}

var allCard:[Card] = [
    스파크,
    에너지재생,
    정신과부하,
    화염구 ,
    물대포,
    낙뢰 ,
    물벼락,
    물의감옥 ,
    신성한불꽃 ,
    물의순환 ,
    수혈 ,
    불의순환 ,
    도깨비불 ,
    금지된마법 ,
    릴림 ,
    축전 ,
    방전 ,
    암흑광선 ,
    최면 ,
    암시 ,
    폭발의진 ,
    가마솥 ,
    도둑 ,
    마법지팡이 ,
    금광 ,
    보석세공사 ,
    성수 ,
    마나물약 ,
    불잉걸 ,
    수증기응결 ,
    먹구름
]

let 스파크 = Card(name: "스파크", price: 3, usePrice: 1, count: 20, effect: "상대에게 피해를 2 준다.",magicAttribute:.번개,gem: nil,image:UIImage(named: "스파크")!)
let 에너지재생 = Card(name: "에너지재생", price: 4, usePrice: 2, count: 10, effect: "체력을 4 회복한다.",magicAttribute:.빛,gem: nil,image:UIImage(named: "에너지재생")!)
let 정신과부하 = Card(name: "정신과부하", price: 5, usePrice: 1, count: 8, effect: "푸른 젬 5개를 공급처에서 내 손으로 가져온다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "정신과부화")!)
let 화염구 = Card(name: "화염구", price: 4, usePrice: 5, count: 20, effect: "상대에게 피해를 5 준다.",magicAttribute:.불,gem: nil,image:UIImage(named: "화염구")!)
let 물대포 = Card(name: "물대포", price: 4, usePrice: 5, count:20, effect: "상대에게 피해를 5 준다.",magicAttribute:.물,gem: nil,image:UIImage(named: "물대포")!)
let 낙뢰 = Card(name: "낙뢰", price: 4, usePrice: 5, count: 20, effect: "상대에게 피해를 5 준다.",magicAttribute:.번개,gem: nil,image:UIImage(named: "낙뢰")!)
let 물벼락 = Card(name: "물벼락", price: 6, usePrice: 5, count: 4, effect: "상대에게 피해를 7 준다.",magicAttribute:.물,gem: nil,image:UIImage(named: "물벼락")!)
let 물의감옥 = Card(name: "물의감옥", price: 6, usePrice: 7, count: 4, effect: "상대 손패의 카드 3장을 무작위로 버린다.",magicAttribute:.물,gem: nil,image:UIImage(named: "물의감옥")!)
let 신성한불꽃 = Card(name: "신성한불꽃", price: 8, usePrice: 6, count: 10, effect: "상대에게 피해를 4 주고, 체력을 4 회복한다.",magicAttribute:.불,gem: nil,image:UIImage(named: "신성한불꽃")!)
let 물의순환 = Card(name: "물의순환", price: 8, usePrice: 1, count: 4, effect: "체력을 2 회복한다.",magicAttribute:.번개,gem: nil,image:UIImage(named: "물의순환")!)
let 서큐버스 = Card(name: "서큐버스", price: 0, usePrice: 4, count: 0, effect: "상대에게 피해를 5 주고, 내 체력을 5 회복한다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "서큐버스")!)
let 릴림 = Card(name: "릴림", price: 0, usePrice: 5, count: 0, effect: "체력을 10 회복한다. 최대 체력을 넘어 회복했을 경우 그 초과분만큼 상대에게 피해를 준다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "릴림")!)
let 수혈 = Card(name: "수혈", price: 5, usePrice: 5, count: 10, effect: "상대에게 피해를 3 주고, 공급처에서 붉은 젬을 한 장 가져온다.",magicAttribute:.물,gem: nil,image:UIImage(named: "수혈")!)
let 불의순환 = Card(name: "불의순환", price: 8, usePrice: 1, count: 4, effect: "상대에게 피해를 1 주고, 카드를 한 장 뽑고, 공급처에서 불의 순환 카드를 한 장 가져온다.",magicAttribute:.불,gem: nil,image:UIImage(named: "불의순환")!)
let 도깨비불 = Card(name: "도깨비불", price: 6, usePrice: 5, count: 10, effect: "상대에게 피해를 3 주고, 상대의 젬 에너지를 1 깎는다.",magicAttribute:.불,gem: nil,image:UIImage(named: "도깨비불")!)
let 사타나치아 = Card(name: "사타나치아", price: 0, usePrice: 3, count: 0, effect: "상대에게 내 젬 에너지만큼의 피해를 준다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "사타나치아")!)
let 아스타로트 = Card(name: "아스타로트", price: 0, usePrice: 3, count: 0, effect: "상대의 젬 에너지를 5 깎는다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "아스타로트")!)
let 금지된마법 = Card(name: "금지된마법", price: 20, usePrice: 20, count: 1, effect: "게임에서 승리한다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "금지된마법")!)
let 미카엘 = Card(name: "미카엘", price: 0, usePrice: 4, count: 0, effect: "내 젬 에너지만큼 회복한다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil,image:UIImage(named: "미카엘")!)
let 우리엘 = Card(name: "우리엘", price: 0, usePrice: 1, count: 0, effect: "상대에게 피해를 5 주고, 내 체력을 5 회복한다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil,image:UIImage(named: "우리엘")!)
let 가브리엘 = Card(name: "가브리엘", price: 0, usePrice: 4, count: 0, effect: "체력을 10 회복한다. 최대 체력을 넘어 회복했을 경우 그 초과분만큼 상대에게 피해를 준다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil,image:UIImage(named: "가브리엘")!)
let 라파엘 = Card(name: "라파엘", price: 0, usePrice: 4, count: 0, effect: "젬 에너지를 5 늘린다. 사용 후 파괴되며, 구매할 수 없다.",magicAttribute:.빛,gem: nil,image:UIImage(named: "라파엘")!)
let 축전 = Card(name: "축전", price: 5, usePrice: 1, count: 10, effect: "자신에게 피해를 4 주고, 이 카드를 파괴하고, 방전 카드를 가져온다.",magicAttribute:.번개,gem: nil,image:UIImage(named: "축전")!)
let 방전 = Card(name: "방전", price: 0, usePrice: 4, count: 0, effect: "상대에게 피해를 8 주고, 이 카드를 파괴하고, 축전 카드를 가져온다.",magicAttribute:.번개,gem: nil,image:UIImage(named: "방전")!)
let 암흑광선 = Card(name: "암흑광선", price: 5, usePrice: 4, count: 10, effect: "상대에게 피해를 5 주고, 내 덱의 무작위 젬을 하나 파괴한다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "암흑광선")!)
let 최면 = Card(name: "최면", price: 8, usePrice: 5, count: 4, effect: "상대의 덱에 악몽 카드를 두 장 섞어 넣는다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "최면")!)
let 암시 = Card(name: "암시", price: 4, usePrice: 3, count: 10, effect: "상대와 자신의 덱에 악몽 카드를 한 장씩 섞어 넣는다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "암시")!)
let 악몽 = Card(name: "악몽", price: 0, usePrice: 1, count: 1, effect: "자신에게 피해를 1 준다. 구매할 수 없으며, 사용 후 파괴된다.",magicAttribute:.암흑,gem: nil,image:UIImage(named: "악몽")!)
let 폭발의진 = Card(name: "폭발의진", price: 10, usePrice: 10, count: 8, effect: "상대에게 피해를 12 준다.",magicAttribute:.불,gem: nil,image:UIImage(named: "폭발의진")!)
let 가마솥 = Card(name: "가마솥", price: 5, usePrice: 2, count: 10, effect: "내 손패의 카드 한 장을 파괴하고, 그 카드보다 가격이 1 높은 카드 한 장을 공급처에서 선택하여 가져온다.", magicAttribute: .무속성,gem: nil,image:UIImage(named: "가마솥")!)
let 기도 = Card(name: "기도", price: 4, usePrice: 2, count: 20, effect: "체력을 1 회복하고, 카드를 한 장 뽑는다.", magicAttribute: .빛,gem: nil,image:UIImage(named: "기도")!)
let 마법지팡이 = Card(name: "마법지팡이", price: 5, usePrice: 2, count: 8, effect: "카드를 두 장 랜덤으로 얻는다.", magicAttribute: .무속성,gem: nil,image:UIImage(named: "마법지팡이")!)
let 도둑 = Card(name: "도둑", price: 8, usePrice: 5, count: 8, effect: "상대의 젬 에너지만큼 내 젬 에너지를 늘린다.", magicAttribute: .암흑,gem: nil,image:UIImage(named: "도둑")!)
let 금광 = Card(name: "금광", price: 8, usePrice: 2, count: 8, effect: "황금 젬 카드 한 장을 공급처에서 가져온다", magicAttribute: .무속성,gem: nil,image:UIImage(named: "금광")!)
let 보석세공사 = Card(name: "보석세공사", price: 8, usePrice: 5, count: 8, effect: "내 손패의 젬 카드 하나를 파괴하고, 그 상위 단계의 젬을 손으로 가져온다.", magicAttribute: .무속성,gem: nil,image:UIImage(named: "보석세공사")!)
let 성수 = Card(name: "성수", price: 2, usePrice: 3, count: 10, effect: "체력을 3 회복한다.", magicAttribute: .빛,gem: nil,image:UIImage(named: "성수")!)
let 마나물약 = Card(name: "마나물약", price: 3, usePrice: 5, count: 10, effect: "잼 에너지를 4 늘리고, 카드를 한 장 뽑는다.", magicAttribute: .빛,gem: nil,image:UIImage(named: "마나물약")!)
let 불잉걸 = Card(name: "불잉걸", price: 6, usePrice: 4, count: 10, effect: "상대에게 피해를 1 주고, 화염구 카드 한 장을 가져온다.", magicAttribute: .불,gem: nil,image:UIImage(named: "불잉걸")!)
let 수증기응결 = Card(name: "수증기응결", price: 6, usePrice: 4, count: 10, effect: "상대에게 피해를 1 주고, 물대포 카드 한 장을 가져온다.", magicAttribute: .물,gem: nil,image:UIImage(named: "수증기응결")!)
let 먹구름 = Card(name: "먹구름", price: 6, usePrice: 4, count: 10, effect: "상대에게 피해를 1 주고, 낙뢰 카드 한 장을 가져온다.", magicAttribute: .번개,gem: nil,image:UIImage(named: "먹구름")!)

//푸른젬1,붉은젬3,황금젬6,칠흑의젬 10
