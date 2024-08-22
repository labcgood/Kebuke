//
//  UploadOrder.swift
//  Kebuke
//
//  Created by Labe on 2024/8/18.
//

import Foundation

// 上傳用的struct
struct UploadOrder: Codable {
    let records: [UploadRecord]
}

struct UploadRecord: Codable {
    let fields: UploadDrink
}

struct UploadDrink: Codable {
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
