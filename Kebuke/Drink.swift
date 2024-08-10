//
//  Drink.swift
//  Kebuke
//
//  Created by Labe on 2024/7/25.
//

import Foundation
import UIKit

struct Drink {
    let type: DrinkType
    let name: String
    let largePrice: Int
    let middlePrice: Int
    let detail: String
    let makeHot: Bool
}

// 生成Drink時，方便輸入及減少打字錯誤
enum DrinkType:String {
    case 季節限定, 單品茶, 調茶, 雲蓋, 歐蕾
}

// 用於選取Button時的判斷（增加可讀性）
enum DrinkOption:Int {
    case 季節限定, 單品茶, 調茶, 雲蓋, 歐蕾
}

// 生成Drink物件
let drinks:[Drink] = [
    Drink(type: .季節限定, name: "金蘋春芽", largePrice: 70, middlePrice: 60, detail: "蘋果汁與蜂蜜綠茶的清爽特調", makeHot: false),
    Drink(type: .單品茶, name: "熟成紅茶", largePrice: 40, middlePrice: 35, detail: "帶有濃穩果香的經典紅茶", makeHot: true),
    Drink(type: .單品茶, name: "麗春紅茶", largePrice: 40, middlePrice: 35, detail: "令人傾心淡雅的花香調紅茶", makeHot: true),
    Drink(type: .單品茶, name: "胭脂紅茶", largePrice: 50, middlePrice: 45, detail: "絲絨般果香調與一抹蜜桃風味", makeHot: true),
    Drink(type: .單品茶, name: "金蜜紅茶", largePrice: 50, middlePrice: 60, detail: "舌尖上的蜂蜜尾韻與經典熟成的香氣", makeHot: true),
    Drink(type: .單品茶, name: "春芽綠茶", largePrice: 40, middlePrice: 35, detail: "春滿四溢的青翠綠茶", makeHot: true),
    Drink(type: .單品茶, name: "雪花冷露", largePrice: 40, middlePrice: 35, detail: "古法熬煮而成清沁滑順冬瓜露", makeHot: false),
    Drink(type: .單品茶, name: "熟成冷露", largePrice: 40, middlePrice: 35, detail: "經典紅茶與古法熬煮冬瓜露", makeHot: true),
    Drink(type: .單品茶, name: "春芽冷露", largePrice: 40, middlePrice: 35, detail: "青翠綠茶與古法熬煮冬瓜露", makeHot: true),
    Drink(type: .調茶, name: "熟成檸果", largePrice: 70, middlePrice: 60, detail: "整顆鮮檸檬與經典紅茶清純爽口", makeHot: false),
    Drink(type: .調茶, name: "冷露檸果", largePrice: 70, middlePrice: 60, detail: "整顆鮮檸檬佐古法熬製的冬瓜露", makeHot: false),
    Drink(type: .雲蓋, name: "雲蓋熟成", largePrice: 65, middlePrice: 60, detail: "經典熟成紅茶跳入玫瑰雲蓋般的甜綿", makeHot: false),
    Drink(type: .雲蓋, name: "雲蓋麗春", largePrice: 65, middlePrice: 60, detail: "淡花香的麗春跳入玫瑰雲蓋般的甜綿", makeHot: false),
    Drink(type: .歐蕾, name: "熟成歐蕾", largePrice: 65, middlePrice: 55, detail: "醇厚鮮奶交織經典紅茶的奶茶", makeHot: true),
    Drink(type: .歐蕾, name: "冷露歐蕾", largePrice: 65, middlePrice: 55, detail: "古法熬煮的冬瓜露遇上醇厚鮮奶", makeHot: true)
]




// 多建立一個用來存取所點飲料資料的struct，以及用來判斷所選SegmentedControl的enum（增加可讀性）
// 用於點選飲料及購物車頁面
struct OrderDrink {
    var drinkName: String
    var capacity: String
    var sugar: String
    var ice: String
    var addOns: String
    var count: Int
    var totalPrice: Int
    var buyersName: String
}

enum DrinkContentOption:Int {
    case 容量, 糖量, 冰量, 加料
}
