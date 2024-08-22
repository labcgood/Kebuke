//
//  OrderDetailViewController.swift
//  Kebuke
//
//  Created by Labe on 2024/7/18.
//

import UIKit
import Kingfisher

class OrderViewController: UIViewController {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkDetailLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    @IBOutlet weak var buyersNameTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var capacitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addOnsSegmentedControl: UISegmentedControl!
    // 判斷溫、熱飲不能加菓玉用
    var iceSelectIndex = 0
    var addOnsSelectIndex = 3
    
    // 存取顯示飲料、所點飲料內容資料
    var currentShowDrink = Drink(type: .單品茶, name: "", largePrice: 0, middlePrice: 0, detail: "", makeHot: true, image: Image(url: ""))
    var orderDrink = OrderDrink(drinkName: "", capacity: "大杯", sugar: "正常", ice: "正常", addOns: "無", count: 1, totalPrice: 0, buyersName: "", imageUrl: "")
    
    // 判斷是新訂單or修改訂單
    var isEdit = false
    var completeEdit: (OrderDrink) -> () = { item in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(orderDrink)
        // Do any additional setup after loading the view.
        buyersNameTextField.delegate = self
        
        // 利用編輯的飲料名稱來找出要顯示的飲料，再把它設定給currentShowDrink（編輯點單用）
        if let drink = drinks.first(where: { $0.name == orderDrink.drinkName }) {
            currentShowDrink = drink
        }
        
        // 顯示目前飲料資訊
        //drinkImageView.image = UIImage(named: currentShowDrink.name)
        let url = URL(string: currentShowDrink.image.url)
        drinkImageView.kf.setImage(with: url)
        
        if currentShowDrink.makeHot == true {
            drinkNameLabel.text = currentShowDrink.name + "Ⓗ"
        } else {
            drinkNameLabel.text = currentShowDrink.name
        }
        
        drinkDetailLabel.text = currentShowDrink.detail
        
        // 初始畫面
        // 利用SegmentedControl的titleForSegment來取得對應的index，讓SegmentedControl在正確的選項（自訂function）
        capacitySegmentedControl.selectedSegmentIndex = decisionSegmentedControlIndex(segmentedControl: capacitySegmentedControl, segmentedControlTitle: orderDrink.capacity)
        sugarSegmentedControl.selectedSegmentIndex = decisionSegmentedControlIndex(segmentedControl: sugarSegmentedControl, segmentedControlTitle: orderDrink.sugar)
        iceSegmentedControl.selectedSegmentIndex = decisionSegmentedControlIndex(segmentedControl: iceSegmentedControl, segmentedControlTitle: orderDrink.ice)
        addOnsSegmentedControl.selectedSegmentIndex = decisionSegmentedControlIndex(segmentedControl: addOnsSegmentedControl, segmentedControlTitle: orderDrink.addOns)
        orderCountLabel.text = "\(orderDrink.count)"
        buyersNameTextField.text = orderDrink.buyersName
        // 變更Button的文字，以符合使用狀態
        if isEdit == false {
            checkButton.setTitle("加  入  購  物  車", for: .normal)
        } else {
            checkButton.setTitle("修  改  訂  單", for: .normal)
        }
        // 重置價錢，以重新計算金額，才不會讓舊金額被疊加上去
        orderDrink.totalPrice = 0
        
        // 鍵盤不擋住TextField的方法
        setKeyboardNotification()
    }
    
    //  判斷SegmentedControl的選項位置
    func decisionSegmentedControlIndex(segmentedControl: UISegmentedControl, segmentedControlTitle: String) -> Int {
        for i in 0..<segmentedControl.numberOfSegments {
            if let title = segmentedControl.titleForSegment(at: i), title == segmentedControlTitle {
                return i
            }
        }
        // 如果沒有篩選出來就設定成沒有選擇的狀態（selectedSegmentIndex = -1）
        return UISegmentedControl.noSegment
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
        // 存取image
        orderDrink.imageUrl = currentShowDrink.image.url
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
        } else if isEdit == false {
            ShoppingCart.shared.cartItems.append(orderDrink)
            self.dismiss(animated: true)
        } else if isEdit == true {
            completeEdit(orderDrink)
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
