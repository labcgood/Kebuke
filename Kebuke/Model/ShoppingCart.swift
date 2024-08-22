//
//  ShoppingCart.swift
//  Kebuke
//
//  Created by Labe on 2024/8/6.
//

import Foundation

// 使用單例模式將加入購物車的資料儲存起來，讓全域使用。
class ShoppingCart {
    static let shared = ShoppingCart()
    
    private init() {
        cartItems = ShoppingCart.load() ?? []
    }
    
    var cartItems:[OrderDrink] = [] {
        didSet {
            ShoppingCart.save(item: cartItems)
        }
    }
    
    // 購物車的商品暫存在App裡，以免關掉App時被清空
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func save(item: [OrderDrink]) {
        guard let data = try? JSONEncoder().encode(item) else { return }
        let url = documentsDirectory.appendingPathComponent("cartItems")
        try? data.write(to: url)
    }
    
    static func load() -> [OrderDrink]? {
        let url = documentsDirectory.appendingPathComponent("cartItems")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([OrderDrink].self, from: data)
    }
}
