//
//  TutorialViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        pageControl.addTarget(self, action: #selector(self.didChangePageControlValue), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }

    @IBAction func skipAction(_ sender: Any) {
        guard let _ = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String else {
            // chưa có account Login
            let enterPhoneVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumberAuthenNavi") as! UINavigationController

            self.present(enterPhoneVC, animated: true, completion: nil)
            return
        }

//        Đã có account Login
        let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewControllerNavi") as! UINavigationController
        self.present(loginVC, animated: true, completion: nil)
    }
    @IBAction func nextAction(_ sender: Any) {
        if tutorialPageViewController != nil {
            // get current index child view and check to start
            print("1111")
        } else {
            print("2222")
        }
        tutorialPageViewController?.scrollToNextViewController()
    }

    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    @objc func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {

    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }

    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {

        pageControl.currentPage = index
    }

}
