//
//  OrderDetailViewController.swift
//  Kebuke
//
//  Created by Labe on 2024/7/18.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkDetailLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    @IBOutlet weak var buyersNameTextField: UITextField!
    
    // 判斷溫、熱飲不能加菓玉用
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addOnsSegmentedControl: UISegmentedControl!
    var iceSelectIndex = 0
    var addOnsSelectIndex = 3
    
    // 存取顯示飲料、所點飲料內容資料
    var currentShowDrink = Drink(type: .單品茶, name: "", largePrice: 0, middlePrice: 0, detail: "", makeHot: true)
    var orderDrink = OrderDrink(drinkName: "", capacity: "大杯", sugar: "正常", ice: "正常", addOns: "無", count: 1, totalPrice: 0, buyersName: "")


    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentShowDrink)
        // Do any additional setup after loading the view.
        buyersNameTextField.delegate = self
        
        // 顯示目前飲料資訊
        drinkImageView.image = UIImage(named: currentShowDrink.name)
        if currentShowDrink.makeHot == true {
            drinkNameLabel.text = currentShowDrink.name + "Ⓗ"
        } else {
            drinkNameLabel.text = currentShowDrink.name
        }
        drinkDetailLabel.text = currentShowDrink.detail
        
        // 鍵盤不擋住TextField的方法
        setKeyboardNotification()
    }
    
    
    // 將SegmentedControl選擇的選項文字設定給orderDrink
    // 有些飲品不做溫、熱飲，所以在冰量欄位會做判斷
    // 在冰量及加料欄位需判斷菓玉不得做溫、熱飲
    // 記下原本選項的index，讓SegmentedControl選項可以維持在原來的選擇
    @IBAction func selecDrinkContent(_ sender: UISegmentedControl) {
        let option = DrinkContentOption(rawValue: sender.tag)
        switch option {
        case .容量:
            orderDrink.capacity = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        case .糖量:
            orderDrink.sugar = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        case .冰量:
            // 判斷不可做熱飲
            if (currentShowDrink.makeHot == false && sender.selectedSegmentIndex == 6) || (currentShowDrink.makeHot == false && sender.selectedSegmentIndex == 7) {
                showAlerController(alerTitle: "不可做溫、熱飲")
                sender.selectedSegmentIndex = iceSelectIndex
            }
            // 菓玉
            if (addOnsSegmentedControl.selectedSegmentIndex == 2 && sender.selectedSegmentIndex == 6) || (addOnsSegmentedControl.selectedSegmentIndex == 2 && sender.selectedSegmentIndex == 7) {
                showAlerController(alerTitle: "溫、熱飲不得加菓玉")
                sender.selectedSegmentIndex = iceSelectIndex
            } else {
                iceSelectIndex = sender.selectedSegmentIndex
            }
            orderDrink.ice = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        case .加料:
            if (iceSegmentedControl.selectedSegmentIndex == 6 && sender.selectedSegmentIndex == 2) || (iceSegmentedControl.selectedSegmentIndex == 7 && sender.selectedSegmentIndex == 2) {
                showAlerController(alerTitle: "溫、熱飲不得加菓玉")
                sender.selectedSegmentIndex = addOnsSelectIndex
                print(sender.selectedSegmentIndex)
            } else {
                addOnsSelectIndex = sender.selectedSegmentIndex
            }
            orderDrink.addOns = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        default:
            break
        }
    }
    
    // 跳出提醒（因為多個地方都會用到，所以獨立寫出一個function，方便使用）
    func showAlerController(alerTitle: String) {
        let alerController = UIAlertController(title: alerTitle, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .cancel)
        alerController.addAction(okAction)
        present(alerController, animated: true)
    }
    
    // 杯數
    @IBAction func orderCount(_ sender: UIButton) {
        let option = sender.tag
        switch option {
        case 0:
            if orderDrink.count > 1 {
                orderDrink.count -= 1
            }
            orderCountLabel.text = "\(orderDrink.count)"
        case 1:
            orderDrink.count += 1
            orderCountLabel.text = "\(orderDrink.count)"
        default:
            break
        }
    }
    
    // 存取飲料的其他資訊
    func updateOrderDrinkInfo() {
        // 存取飲品名稱
        orderDrink.drinkName = currentShowDrink.name
        // 存取訂購人名稱
        if let name = buyersNameTextField.text {
            orderDrink.buyersName = name
        }
        // 存取總金額
        if orderDrink.capacity == "大杯" {
            orderDrink.totalPrice += currentShowDrink.largePrice * orderDrink.count
        } else if orderDrink.capacity == "中杯" {
            orderDrink.totalPrice += currentShowDrink.middlePrice * orderDrink.count
        }
        if orderDrink.addOns != "無" {
            orderDrink.totalPrice += 10 * orderDrink.count
        }
    }
    
    // 加入購物車
    @IBAction func addToCart(_ sender: Any) {
        updateOrderDrinkInfo()
        // 判斷是否有輸入訂購人名稱，沒有輸入的話跳出通知，有輸入就關掉頁面（之後會再加把資料傳到購物車的功能）
        if buyersNameTextField.text == nil || buyersNameTextField.text == "" {
            showAlerController(alerTitle: "請輸入訂購人名稱")
            print(orderDrink)
        } else {
            print(orderDrink)
            self.dismiss(animated: true)
        }
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


// TextField設定：收鍵盤、打字時移動View不擋住TextField
extension OrderViewController: UITextFieldDelegate {
    
    // 點選return收回鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    // 根據鍵盤的顯示、收起的動作來決定移動View
    func setKeyboardNotification() {
        let center:NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 將View上移
    @objc func keyboardShown(notification: Notification) {
        // 取得鍵盤尺寸
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // 計算鍵盤頂部的y座標、TextField底部的y座標，相減得到兩者距離（且如果數字大於0，就表示有被擋住，小於0則否）
        let keyboardTopY = self.view.frame.height - keyboardSize.height
        let buyersNameTextFieldBottomY = self.buyersNameTextField.convert(buyersNameTextField.bounds, to: self.view).maxY
        let targetY = Int(buyersNameTextFieldBottomY - keyboardTopY)
        
        // 判斷如果有被遮住就移動（View要往上移，y軸就要是負數）
        // 除了鍵盤移動的距離，這邊多加了80是因為鍵盤上會有預設輸入選項，這也會擋到TextField，所以我自己測試後決定多+80
        if self.view.frame.minY >= 0 {
            if targetY > 0 {
                UIView.animate(withDuration: 0.25) {
                    self.view.frame = CGRect(x: 0, y: -(targetY + 80), width: Int(self.view.frame.width), height: Int(self.view.frame.height))
                }
            }
        }
    }
    
    // 將View移動回來
    @objc func keyboardHidden(notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height))
        }
    }
}
