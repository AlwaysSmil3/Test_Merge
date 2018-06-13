//
//  WebViewViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

enum WebViewType {
    case termView
    case aboutView
}

class WebViewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var webViewType: WebViewType = .termView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch webViewType {
        case .termView:
            self.title = NSLocalizedString("TERMS_OF_USE", comment: "")
        default:
            self.title = NSLocalizedString("ABOUT_FINSMART", comment: "")
        }
        
        let url = URL(string: "http://five9.vn/about-us")
        let requestObj = URLRequest(url: url!)
        self.webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
