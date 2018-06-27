//
//  BaseViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    
    @IBOutlet var btnContinue: UIButton?
    @IBOutlet var imgBgBtnContinue: UIImageView?
    
    func setupTitleView(title: String, subTitle: String) {
        let topText = NSLocalizedString(title, comment: "")
        let bottomText = NSLocalizedString(subTitle, comment: "")
        
        let titleParameters = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#08121E"),
                               NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_BOLD, size: 17)]
        let subtitleParameters = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#4D6678"),
                                  NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_REGULAR, size: 11)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        
        let width = size.width
        guard let height = navigationController?.navigationBar.frame.size.height else {return}
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        self.navigationItem.titleView = titleLabel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add shadow for button
        if let btn = self.btnContinue {
            btn.dropShadow(color: DISABLE_BUTTON_COLOR)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("----- deinit: \(String(describing: self.self))")
    }
    
    
    /// cho trạng thái enable hay disable button
    ///
    /// - Parameter isEnable: <#isEnable description#>
    func isEnableContinueButton(isEnable: Bool) {
        guard isEnable else {
            if let imgbg = self.imgBgBtnContinue {
                imgbg.image = #imageLiteral(resourceName: "bg_button_disable_login")
            }
            
            if let btn = self.btnContinue {
                btn.dropShadow(color: DISABLE_BUTTON_COLOR)
                btn.isEnabled = false
            }
            
            return
        }
        
        if let imgBg = self.imgBgBtnContinue {
            imgBg.image = #imageLiteral(resourceName: "bg_button_enable_login")
        }
        
        if let btn = self.btnContinue {
            btn.dropShadow(color: MAIN_COLOR)
            btn.isEnabled = true
        }
        
    }
    
    // MARK: - Action
    
    
    @IBAction func btnBackCurrentClicked(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackToRootClicked(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}


