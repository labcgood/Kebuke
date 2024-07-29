//
//  Drink.swift
//  Kebuke
//
//  Created by Labe on 2024/7/25.
//

import Foundation

struct Drink {
    let type: Type
    let name: String
    let largePrice: Int
    let middlePrice: Int
}

// 生成Drink時，方便輸入及減少打字錯誤
enum Type:String {
    case 季節限定, 單品茶, 調茶, 雲蓋, 歐蕾
}

// 用於選取Button時的判斷（增加可讀性）
enum DrinkOption:Int {
    case 季節限定, 單品茶, 調茶, 雲蓋, 歐蕾
}

let drinks:[Drink] = [
    Drink(type: .季節限定, name: "金蘋春芽", largePrice: 70, middlePrice: 60),
    Drink(type: .單品茶, name: "熟成紅茶", largePrice: 40, middlePrice: 35),
    Drink(type: .單品茶, name: "麗春紅茶", largePrice: 40, middlePrice: 35),
    Drink(type: .單品茶, name: "胭脂紅茶", largePrice: 50, middlePrice: 45),
    Drink(type: .單品茶, name: "金蜜紅茶", largePrice: 50, middlePrice: 60),
    Drink(type: .單品茶, name: "春芽綠茶", largePrice: 40, middlePrice: 35),
    Drink(type: .單品茶, name: "雪花冷露", largePrice: 40, middlePrice: 35),
    Drink(type: .單品茶, name: "熟成冷露", largePrice: 40, middlePrice: 35),
    Drink(type: .單品茶, name: "春芽冷露", largePrice: 40, middlePrice: 35),
    Drink(type: .調茶, name: "熟成檸果", largePrice: 70, middlePrice: 60),
    Drink(type: .調茶, name: "冷露檸果", largePrice: 70, middlePrice: 60),
    Drink(type: .雲蓋, name: "雲蓋熟成", largePrice: 65, middlePrice: 60),
    Drink(type: .雲蓋, name: "雲蓋麗春", largePrice: 65, middlePrice: 60),
    Drink(type: .歐蕾, name: "熟成歐蕾", largePrice: 65, middlePrice: 55),
    Drink(type: .歐蕾, name: "冷露歐蕾", largePrice: 65, middlePrice: 55)
]
