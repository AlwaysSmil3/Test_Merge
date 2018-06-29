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
    @IBOutlet weak var borderView: UIView!
    
    var webViewType: WebViewType = .termView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        self.borderView.layer.cornerRadius = 8
        
//        let url = URL(string: "http://five9.vn/about-us")
//        let requestObj = URLRequest(url: url!)
//        self.webView.loadRequest(requestObj)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ishidden = self.navigationController?.isNavigationBarHidden, ishidden {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        var htmlPath = ""
        
        switch webViewType {
        case .termView:
            self.title = NSLocalizedString("TERMS_OF_USE", comment: "")
            htmlPath = Bundle.main.path(forResource: "terms-and-conditions", ofType: "html")!
        default:
            self.title = NSLocalizedString("ABOUT_FINSMART", comment: "")
            htmlPath = Bundle.main.path(forResource: "about", ofType: "html")!
        }
        
        let url = URL(fileURLWithPath: htmlPath)
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
