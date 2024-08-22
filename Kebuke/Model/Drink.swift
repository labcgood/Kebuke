//
//  Drink.swift
//  Kebuke
//
//  Created by Labe on 2024/7/25.
//

import Foundation
import UIKit

struct Menu:Codable {
    let records:[Record]
}

struct Record:Codable {
    let fields:ResponseDrink
}

struct ResponseDrink:Codable {
    let type: DrinkType
    let name: String
    let largePrice: Int
    let middlePrice: Int
    let detail: String
    let makeHot: Bool?
    let image: [Image]
}

struct Image: Codable {
    let url: String
}



struct Drink:Codable {
    let type: DrinkType
    let name: String
    let largePrice: Int
    let middlePrice: Int
    let detail: String
    let makeHot: Bool
    let image: Image
}

// 方便輸入茶品種類及減少打字錯誤
enum DrinkType:String, Codable {
    case 季節限定, 單品茶, 調茶, 雲蓋, 歐蕾
}

// 用於選取Button時的判斷（增加可讀性）
enum DrinkOption:Int {
    case 季節限定, 單品茶, 調茶, 雲蓋, 歐蕾
}

var drinks:[Drink] = []





// 多建立一個用來存取所點飲料資料的struct，以及用來判斷所選SegmentedControl的enum（增加可讀性）
// 用於點選飲料及購物車頁面
struct OrderDrink: Codable {
    var drinkName: String
    var capacity: String
    var sugar: String
    var ice: String
    var addOns: String
    var count: Int
    var totalPrice: Int
    var buyersName: String
    var imageUrl: String
}

enum DrinkContentOption:Int {
    case 容量, 糖量, 冰量, 加料
}
