//
//  HomeViewController.swift
//  Kebuke
//
//  Created by Labe on 2024/7/18.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var adScrollView: UIScrollView!
    @IBOutlet weak var adStackView: UIStackView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adPageControl: UIPageControl!
    @IBOutlet weak var drinkCollectionView: UICollectionView!
    @IBOutlet var drinkTypeButtons: [UIButton]!
    
    
    var adImages = ["ad1", "ad2", "ad3", "ad4", "ad5"]
    var bannerTimer: Timer?
    
    var selectDrinks:[Drink] = [] //分類後要顯示的飲料
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        adScrollView.delegate = self
        drinkCollectionView.delegate = self
        drinkCollectionView.dataSource = self
        
        for i in 0...drinkTypeButtons.count-1 {
            drinkTypeButtons[i].layer.cornerRadius = 17
        }
        
        setupAdPageControl()
        addAd(imageNameArray: adImages)
        setupTimer()
        
        fetchMenuData()
    }
    
    // 接API抓取資料
    func fetchMenuData() {
        if let url = URL(string: "https://api.airtable.com/v0/appazyAIzHhfRorTX/Drink") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data {
                    let decoder = JSONDecoder()
                    do {
                        let menuResponse = try decoder.decode(Menu.self, from: data)
                        
                        // 轉換資料：因為Airtable上的makeHot我是使用Checkbox類型去存取，如果資料不是true，就不會有makeHot這個屬性，所以我將makeHot=nil的物件轉成makeHot=false；image因為是用array包著的資料，我直接將array的第0筆資料設定給tmpItem的image
                        let transformDrinks = menuResponse.records.map({
                            let tmpItem = $0.fields
                            return Drink(type: tmpItem.type, name: tmpItem.name, largePrice: tmpItem.largePrice, middlePrice: tmpItem.middlePrice, detail: tmpItem.detail, makeHot: tmpItem.makeHot ?? false, image: tmpItem.image[0])
                        })
                        // 將抓取的菜單設定給drinks
                        drinks = transformDrinks
                        
                        // 處理顯示畫面的動作(篩選初始要顯示的飲料、更新collectionView)
                        DispatchQueue.main.async {
                            self.filterDrinkOfType(type: .季節限定)
                            self.drinkCollectionView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    // 設定PageControl
    func setupAdPageControl() {
        adPageControl.numberOfPages = adImages.count
        adPageControl.pageIndicatorTintColor = .white
        adPageControl.currentPageIndicatorTintColor = .gray
        adPageControl.currentPage = 0
    }
    
    func addAd(imageNameArray: [String]) {
        // 加入廣告圖片
        adImageView.image = UIImage(named: imageNameArray[imageNameArray.count-1])
        for i in 0...imageNameArray.count-1 {
            let imageView = UIImageView(image: UIImage(named: imageNameArray[i]))
            imageView.contentMode = .scaleAspectFit
            adStackView.addArrangedSubview(imageView)
        }
        let firstAdImageView = UIImageView(image: UIImage(named: imageNameArray[0]))
        firstAdImageView.contentMode = .scaleAspectFit
        adStackView.addArrangedSubview(firstAdImageView)
        
        // 初始顯示位置
        adScrollView.contentOffset = CGPoint(x: view.frame.width, y: 0)
    }
    
    // 設定Timer 3秒切換一次廣告
    func setupTimer() {
        stopTimer() // 確保生成Timer前，消除已存在的Timer，以免重複存在
        
        self.bannerTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
            if (self.adImages.count > 1) {
                let index = (self.adPageControl.currentPage + 1) % (self.adImages.count + 1)
                self.adScrollView.setContentOffset(CGPoint(x: CGFloat(index + 1) * self.view.frame.width, y: 0), animated: true)
            } else {
                self.stopTimer()
            }
        })
        RunLoop.current.add(self.bannerTimer!, forMode: .common)
        // self.bannerTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    /*
        @objc func autoScroll() {
            // 如果數量大於一，滑動
            if (adImages.count > 1) {
                let index = (adPageControl.currentPage + 1) % (adImages.count + 1)
                adScrollView.setContentOffset(CGPoint(x: CGFloat(index + 1) * view.frame.width, y: 0), animated: true)
            } else {
                stopTimer()
            }
        }
    */
    
    // 消除已存在的Timer
    func stopTimer() {
        if bannerTimer != nil {
            bannerTimer?.invalidate()
        }
    }
    
    // 判斷目前選取的飲料種類
    @IBAction func selectDrinkType(_ sender: UIButton) {
        let option = DrinkOption(rawValue: sender.tag)
        switch option {
        case .季節限定:
            filterDrinkOfType(type: .季節限定)
        case .單品茶:
            filterDrinkOfType(type: .單品茶)
        case .調茶:
            filterDrinkOfType(type: .調茶)
        case .雲蓋:
            filterDrinkOfType(type: .雲蓋)
        case .歐蕾:
            filterDrinkOfType(type: .歐蕾)
        default:
            break
        }
        self.drinkCollectionView.reloadData()
    }
    
    // 篩選各種類的飲料，設定給selectDrinks，讓CollectionView顯示出來
    func filterDrinkOfType(type: DrinkType) {
        let currentDrinkType = drinks.filter { $0.type == type }
        selectDrinks = currentDrinkType
        // 切換分類時要讓CollectionView從頂部開始顯示
        self.drinkCollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    

    // 將所點選飲料資料傳到OrderViewController顯示
    @IBSegueAction func toOrderViewController(_ coder: NSCoder) -> OrderViewController? {
        let controller = OrderViewController(coder: coder)
        guard let index = self.drinkCollectionView.indexPathsForSelectedItems?.first?.item else { return nil }
        controller?.currentShowDrink = selectDrinks[index]
        controller?.isEdit = false
        return controller
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

// 擴展HomeViewController，遵循UIScrollViewDelegate來控制滑動廣告時Timer的變化(滑動時應該停止，放開時再次啟動)，以及無限輪播效果(上文步驟裡有提到的效果)
// 在使用功能時都先判斷scrollView是我們的adScrollView，不然在其他元件滑動時，會影響到Timer運行，我遇到的問題就是滑動飲料的CollectionView時，廣告就會停止輪播
extension HomeViewController: UIScrollViewDelegate {
    
    // scrollView開始滑動時，消除Timer
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == adScrollView {
            if adImages.count > 0 {
                stopTimer()
            }
        }
    }
    
    // scrollView停止滑動時，生成Timer，開始輪播
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == adScrollView {
            if adImages.count > 0 {
                setupTimer()
            }
        }
    }
    
    // scrollView內容發生滾動時，無限輪播、PageControl轉跳
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == adScrollView {
            let currentX = adScrollView.contentOffset.x
            if currentX == 0 {
                let lastAdContentOffsetX = scrollView.frame.width * CGFloat(adImages.count)
                adScrollView.contentOffset = CGPoint(x: lastAdContentOffsetX, y: 0)
            } else if currentX == scrollView.frame.width * CGFloat(adImages.count + 1) {
                adScrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
            }
            
            if scrollView == self.adScrollView {
                let page = round(scrollView.contentOffset.x / scrollView.frame.width) - 1
                self.adPageControl.currentPage = Int(page)
            }
        }
    }
}

// 擴展HomeViewController，遵循UICollectionViewDelegate、UICollectionViewDataSource，顯示飲料
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCollectionViewCell.reuseIdentifier, for: indexPath) as! DrinkCollectionViewCell
        // 顯示圖片
//        let image = UIImage(named: selectDrinks[indexPath.item].name)
//        cell.drinkImageView.image = image
        let url = URL(string: selectDrinks[indexPath.item].image.url)
        cell.drinkImageView.kf.setImage(with: url)
        // 顯示飲料名稱(可做熱飲後面+Ⓗ)
        if selectDrinks[indexPath.item].makeHot == true {
            cell.drinkNameLabel.text = selectDrinks[indexPath.item].name + "Ⓗ"
        } else {
            cell.drinkNameLabel.text = selectDrinks[indexPath.item].name
        }
        // 顯示飲料價格
        cell.drinkPriceLabel.text = "中:\(selectDrinks[indexPath.item].middlePrice)／大:\(selectDrinks[indexPath.item].largePrice)"
        setupCellSize()
        return cell
    }
    
    func setupCellSize() {
        let itemSpace: Double = 3
        let columCount: Double = 2
        // 為了使用flowLayout屬性(用來排版、控制cell大小)，所以我們這邊進行轉型。
        let flowLayout = self.drinkCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        // cell大小
        let width = floor((self.drinkCollectionView.bounds.width - itemSpace * (columCount-1)) / columCount)
        flowLayout?.itemSize = CGSize(width: width, height: width)
        // 將預設尺寸設為0，讓CollectionViewCell不會用AutoLayout去算尺寸，或在StoryBoard把CollectionViewCell的EstimateSize設定成None也可以
        flowLayout?.estimatedItemSize = .zero
        // 間距設定
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.minimumInteritemSpacing = itemSpace
    }
    
    
}
