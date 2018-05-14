//
//  APIClient.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JWT

typealias JSONDictionary = [String: Any]

class APIClient {
    
    static let shared = APIClient()
    
    //Host
    #if DEVELOPMENT
    let baseURLString = Host.alphaURL
    #else
    let baseURLString = Host.productURL
    #endif
    
    // POST request
    internal var postRequest : NSMutableURLRequest! {
        get {
            // Init post request
            let _postRequest = NSMutableURLRequest()
            _postRequest.httpMethod = "POST"
            _postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            _postRequest.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
            return _postRequest
        }
    }
    
    // GET request
    internal var getRequest : NSMutableURLRequest! {
        get {
            // Init get request
            let _getRequest = NSMutableURLRequest()
            _getRequest.httpMethod = "GET"
            _getRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            _getRequest.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "Accept")
            return _getRequest
        }
    }
    
    init() {
        bypassURLAuthentication()
    }
    
    
    // MARK: - Common function
    // Request post
    public func postRequestWithEndPoint(endPoint: String, params: [String : Any]) -> Promise<JSONDictionary> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let mutableURLRequest = self.postRequest!
        
        return Promise { fullfill, reject in
            mutableURLRequest.url = URL(string: baseURLString + endPoint)
            mutableURLRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            Alamofire.request(mutableURLRequest as URLRequest).responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                case .failure(let error):
                    reject(error)
                    UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: self.getDisplayMessage(error: error), okTitle: "OK", cancelTitle: nil)
                    
                case .success(let responseObject):
                    
                    if let responseDataDict = responseObject as? JSONDictionary {
                        
                        fullfill(responseDataDict)
                    }
                    else {
                        
                        print("fail to parser data")
                        let error = NSError(domain: "BackendManager", code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: API_MESSAGE.OTHER_ERROR])
                        reject(error)
                        UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: API_MESSAGE.DATA_FORMART_ERROR, okTitle: "OK", cancelTitle: nil)
                    }
                }
            }
        }
    }
    
    // Request get
    public func getDataWithEndPoint(host: String? = nil, endPoint: String) -> Promise<JSONDictionary> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let mutableURLRequest = self.getRequest!
        
        return Promise { fullfill, reject in
            mutableURLRequest.url = URL(string: baseURLString + endPoint)
            
            Alamofire.request(mutableURLRequest as URLRequest).responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                    
                case .failure(let error):
                    
                    reject(error)
                    UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: self.getDisplayMessage(error: error), okTitle: "OK", cancelTitle: nil)
                    
                case .success(let responseObject):
                    
                    if let responseDataDict = responseObject as? JSONDictionary {
                        
                        fullfill(responseDataDict)
                    }
                    else {
                        
                        print("fail to parser data")
                        let error = NSError(domain: "BackendManager", code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: API_MESSAGE.OTHER_ERROR])
                        reject(error)
                        UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: API_MESSAGE.DATA_FORMART_ERROR, okTitle: "OK", cancelTitle: nil)
                    }
                }
            }
        }
    }
    
    // Display message
    public func getDisplayMessage(error: Error) -> String {
        
        var errMessage = ""
        
        let err = error as NSError
        
        if  err.code == NSURLErrorNotConnectedToInternet {
            // no internet connection
            errMessage = API_MESSAGE.NO_INTERNET
        }
        else {
            // other failures
            errMessage = API_MESSAGE.OTHER_ERROR
        }
        
        return errMessage
    }
    
    // default error
    public func createUnknowError(forDomain domain: String?) -> NSError {
        
        return createError(withMessage: API_MESSAGE.OTHER_ERROR, forDomain: domain ?? "")
    }
    
    private func createError(withMessage message: String, forDomain domain: String?) -> NSError {
        
        return NSError(domain: domain ?? "", code: 0,
                       userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    /**
     By pass SSL Certificate
     */
    private func bypassURLAuthentication() {
        let manager = Alamofire.SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }
    
    
    
    
}
