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
    case contractView
}

class WebViewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var borderView: UIView!
    
    var webViewType: WebViewType = .termView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        self.borderView.layer.cornerRadius = 8
        
        self.webView.delegate = self
        
        self.webView.scrollView.showsVerticalScrollIndicator = false;
        self.webView.scrollView.showsHorizontalScrollIndicator = false;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ishidden = self.navigationController?.isNavigationBarHidden, ishidden {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        //        var htmlPath = ""
        var url: URL?
        
        switch webViewType {
        case .termView:
            self.title = NSLocalizedString("TERMS_OF_USE", comment: "")
            url = URL(string: DataManager.shared.config?.policy ?? "")
            break
        case .aboutView:
            self.title = NSLocalizedString("ABOUT_FINSMART", comment: "")
            url = URL(string: DataManager.shared.config?.about ?? "")
            break
        case .contractView:
            self.title = "Điều khoản & Điều kiện vay"
            url = URL(string: DataManager.shared.config?.policyBorrow ?? "")
            break

        }
        
        //        let url = URL(fileURLWithPath: htmlPath)
        if let url_ = url {
            let request = URLRequest(url: url_)
            self.webView.loadRequest(request)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
