//
//  OrderDetailViewController.swift
//  Kebuke
//
//  Created by Labe on 2024/7/19.
//

import UIKit
import Kingfisher

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var orderDrinksTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var submitTheOrderButton: UIButton!
    @IBOutlet weak var noItemImageView: UIImageView!
    
    var addDrink = OrderDrink(drinkName: "", capacity: "", sugar: "", ice: "", addOns: "", count: 0, totalPrice: 0, buyersName: "", imageUrl: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        orderDrinksTableView.delegate = self
        orderDrinksTableView.dataSource = self
        
        submitTheOrderButton.layer.cornerRadius = 15
    }

    override func viewWillAppear(_ animated: Bool) {
        // 更新畫面
        orderDrinksTableView.reloadData()
        buttonIsEnable()
        // 計算總金額並顯示
        calculateTotalPrice()
    }
    
    // 計算總金額
    func calculateTotalPrice() {
        let totalPrice = ShoppingCart.shared.cartItems.reduce(0) { $0 + $1.totalPrice }
        totalPriceLabel.text = "＄\(totalPrice)"
    }
    
    // 判斷是否可使用送出訂單的Button
    func buttonIsEnable() {
        if ShoppingCart.shared.cartItems.isEmpty == true {
            submitTheOrderButton.isEnabled = false
            noItemImageView.isHidden = false
        } else {
            submitTheOrderButton.isEnabled = true
            noItemImageView.isHidden = true
        }
    }
    
    // 修改訂單
    @IBSegueAction func toOrderVC(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> OrderViewController? {
        // 取得選取Cell的Row，把相應位置的資料傳給編輯頁面，isEdit設定成true（讓頁面知道這是修改訂單而不是新訂單），修改完成時在按下Button時會呼叫completeEdit，執行這邊寫的Code
        guard let row = orderDrinksTableView.indexPathForSelectedRow?.row else { return nil }
        let controll = OrderViewController(coder: coder)
        controll?.orderDrink = ShoppingCart.shared.cartItems[row]
        controll?.isEdit = true
        controll?.completeEdit = { drink in
            ShoppingCart.shared.cartItems[row] = drink
            
            guard let indexPath = self.orderDrinksTableView.indexPathForSelectedRow else { return }
            self.orderDrinksTableView.reloadRows(at: [indexPath], with: .automatic)
            //self.orderDrinksTableView.reloadData()
            self.calculateTotalPrice()
        }
        return controll
    }
    
    // 送出訂單（上傳）
    @IBAction func submitTheOrder(_ sender: UIButton) {
        let url = URL(string: "https://api.airtable.com/v0/appazyAIzHhfRorTX/Order")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 資料類型轉換成UploadOrder（才可以上傳）
        let transformDrinks = ShoppingCart.shared.cartItems.map({
            UploadRecord(fields: UploadDrink(drinkName: $0.drinkName, capacity: $0.capacity, sugar: $0.sugar, ice: $0.ice, addOns: $0.addOns, count: $0.count, totalPrice: $0.totalPrice, buyersName: $0.buyersName, imageUrl: $0.imageUrl))
/*          保留以上簡潔的寫法
            let tmpItem = $0
            let drink = UploadDrink(drinkName: tmpItem.drinkName, capacity: tmpItem.capacity, sugar: tmpItem.sugar, ice: tmpItem.ice, addOns: tmpItem.addOns, count: tmpItem.count, totalPrice: tmpItem.totalPrice, buyersName: tmpItem.buyersName, imageUrl: tmpItem.imageUrl)
            let orderRecord = OrderRecord(fields: drink)
            return orderRecord
 */
        })
        let uploadOrder = UploadOrder(records: transformDrinks)
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(uploadOrder)
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let content = String(data: data, encoding: .utf8) {
                print(content)
            }
        }.resume()
        
        // 上傳成功提示
        let alerController = UIAlertController(title: "訂單上傳成功", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .cancel)
        alerController.addAction(okAction)
        present(alerController, animated: true)
        
        // 清空購物車
        ShoppingCart.shared.cartItems.removeAll()
        self.orderDrinksTableView.reloadData()
        self.buttonIsEnable()
        self.calculateTotalPrice()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ShoppingCart.shared.cartItems.count
    }
    
    // 顯示Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDrinksTableViewCell.reuseIdentifier, for: indexPath) as? OrderDrinksTableViewCell else { fatalError() }
        let url = URL(string: ShoppingCart.shared.cartItems[indexPath.row].imageUrl)
        cell.drinkImageView.kf.setImage(with: url)
        cell.nameSizeAndCountLabel.text = "【\(ShoppingCart.shared.cartItems[indexPath.row].drinkName)】\(ShoppingCart.shared.cartItems[indexPath.row].capacity)*\(ShoppingCart.shared.cartItems[indexPath.row].count)杯"
        cell.sugarAndIceLabel.text = "糖量:\(ShoppingCart.shared.cartItems[indexPath.row].sugar)／冰量:\(ShoppingCart.shared.cartItems[indexPath.row].ice)"
        cell.addOnsLabel.text = "加料：\(ShoppingCart.shared.cartItems[indexPath.row].addOns)"
        cell.buyersNameLabel.text = "訂購人：\(ShoppingCart.shared.cartItems[indexPath.row].buyersName)"
        cell.priceLabel.text = "金額：\(ShoppingCart.shared.cartItems[indexPath.row].totalPrice)元"
        return cell
    }
    
    // 刪除訂單
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ShoppingCart.shared.cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.calculateTotalPrice()
            buttonIsEnable()
        }
    }
}
