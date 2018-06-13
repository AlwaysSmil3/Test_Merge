//
//  OnBoardViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class OnBoardViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    let totalPage = 3

    @IBAction func skipBtnAction(_ sender: Any) {
        guard let _ = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String else {
            // chưa có account Login
            let enterPhoneVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumberAuthenNavi") as! UINavigationController

            self.present(enterPhoneVC, animated: true, completion: nil)
            return
        }
        print("account \(userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME))")
        let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewControllerNavi") as! UINavigationController
        self.present(loginVC, animated: true, completion: nil)
    }

    @IBAction func nextBtnAction(_ sender: Any) {
        let currentIndex = getCurrentScrollViewIndex()
        if (currentIndex + 1 < totalPage) {
            let nextIndex = currentIndex + 1
            scrollView.scrollRectToVisible(CGRect(x: CGFloat(nextIndex) * scrollView.frame.width, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
        } else {
            skipBtnAction(skipBtn)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.isUserInteractionEnabled = false
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = getCurrentScrollViewIndex()
        if getCurrentScrollViewIndex() + 1 == totalPage {
            nextBtn.setTitle("BẮT ĐẦU", for: UIControlState.normal)
            skipBtn.isHidden = true
        } else {
            nextBtn.setTitle("TIẾP", for: UIControlState.normal)
            skipBtn.isHidden = false
        }
    }

    func getCurrentScrollViewIndex() -> Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.width)
    }

}
