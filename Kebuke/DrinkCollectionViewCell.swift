//
//  DrinkCollectionViewCell.swift
//  Kebuke
//
//  Created by Labe on 2024/7/25.
//

import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {
    
    // 在設定cell要顯示的內容時，我們會用到轉型，在轉型時會需要輸入cell的id，為了預防我們打錯字或是增加程式可讀性，我們在這邊定義reuseIdentifier屬性，在使用時可以用DrinkCollectionViewCell.reuseIdentifier來呼叫
    static let reuseIdentifier = "\(DrinkCollectionViewCell.self)"
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkPriceLabel: UILabel!

}
