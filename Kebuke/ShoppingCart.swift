//
//  ShoppingCart.swift
//  Kebuke
//
//  Created by Labe on 2024/8/6.
//

import Foundation

class ShoppingCart {
    static let shared = ShoppingCart()
    
    private init() {}
    
    var cartItems:[OrderDrink] = []
}
