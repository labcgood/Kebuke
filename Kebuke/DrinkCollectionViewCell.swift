//
//  DrinkCollectionViewCell.swift
//  Kebuke
//
//  Created by Labe on 2024/7/25.
//

import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(DrinkCollectionViewCell.self)"
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkPriceLabel: UILabel!

}
