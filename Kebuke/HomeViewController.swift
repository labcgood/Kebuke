//
//  HomeViewController.swift
//  Kebuke
//
//  Created by Labe on 2024/7/18.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var adScrollView: UIScrollView!
    @IBOutlet weak var adStackView: UIStackView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adPageControl: UIPageControl!
    @IBOutlet weak var drinkCollectionView: UICollectionView!
    
    
    var adImages = ["ad1", "ad2", "ad3", "ad4", "ad5"]
    var bannerTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        adScrollView.delegate = self
//        drinkCollectionView.delegate = self
//        drinkCollectionView.dataSource = self
        
        
        setupAdPageControl()
        addAd(imageNameArray: adImages)
        setupTimer()
    }
    
    func setupAdPageControl() {
        adPageControl.numberOfPages = adImages.count
        adPageControl.pageIndicatorTintColor = .white
        adPageControl.currentPageIndicatorTintColor = .gray
        adPageControl.currentPage = 0
    }
    
    func addAd(imageNameArray: [String]) {
        // 初始顯示位置
        adScrollView.contentOffset = CGPoint(x: view.frame.width, y: 0)
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
    }
    
    func setupTimer() {
        stopTimer()
        
        self.bannerTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
            if (self.adImages.count > 1) {
                let index = (self.adPageControl.currentPage + 1) % (self.adImages.count + 1)
                self.adScrollView.setContentOffset(CGPoint(x: CGFloat(index + 1) * self.view.frame.width, y: 0), animated: true)
            } else {
                self.stopTimer()
            }
        })
        // self.bannerTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if bannerTimer != nil {
            bannerTimer?.invalidate()
        }
    }
    
//    @objc func autoScroll() {
//        // 如果數量大於一，滑動
//        if (adImages.count > 1) {
//            let index = (adPageControl.currentPage + 1) % (adImages.count + 1)
//            adScrollView.setContentOffset(CGPoint(x: CGFloat(index + 1) * view.frame.width, y: 0), animated: true)
//        } else {
//            stopTimer()
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if adImages.count > 0 {
            stopTimer()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if adImages.count > 0 {
            setupTimer()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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


//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}
