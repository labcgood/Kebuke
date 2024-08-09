//
//  OrderDrinksTableViewCell.swift
//  Kebuke
//
//  Created by Labe on 2024/8/5.
//

import UIKit

class OrderDrinksTableViewCell: UITableViewCell {
    static let reuseIdentifier = "\(OrderDrinksTableViewCell.self)"
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameSizeAndCountLabel: UILabel!
    @IBOutlet weak var sugarAndIceLabel: UILabel!
    @IBOutlet weak var addOnsLabel: UILabel!
    @IBOutlet weak var buyersNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        drinkImageView.layer.cornerRadius = 13
        // 利用View做出row的間距
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
