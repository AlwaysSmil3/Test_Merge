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

typealias JSONDictionary = [String: Any]

enum HTTPMethodType {
    case POST
    case PUT
    case DELETE
}


class APIClient {
    
    static let shared = APIClient()
    
    //Host
    let baseURLString = Host.productURL
    
    // DELETE request
    internal var deleteRequest : NSMutableURLRequest! {
        get {
            // Init delete request
            let _deleteRequest = NSMutableURLRequest()
            _deleteRequest.httpMethod = "DELETE"
            _deleteRequest.timeoutInterval = REQUEST_TIMEOUT
            _deleteRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            _deleteRequest.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
            return _deleteRequest
        }
    }
    
    // POST request
    internal var postRequest : NSMutableURLRequest! {
        get {
            // Init post request
            let _postRequest = NSMutableURLRequest()
            _postRequest.httpMethod = "POST"
            
            _postRequest.timeoutInterval = REQUEST_TIMEOUT
            
            _postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
            _getRequest.timeoutInterval = REQUEST_TIMEOUT
//            _getRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            _getRequest.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "Accept")
            _getRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            _getRequest.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
            return _getRequest
        }
    }
    
    // PUT request
    internal var putRequest : NSMutableURLRequest! {
        get {
            // Init get request
            let _putRequest = NSMutableURLRequest()
            _putRequest.httpMethod = "PUT"
            _putRequest.timeoutInterval = REQUEST_TIMEOUT
            _putRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            _putRequest.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
            return _putRequest
        }
    }
    
    init() {
        bypassURLAuthentication()
    }
    
    private func hanldeShowLoadingView(isShow: Bool) {
        if let viewController = UIApplication.shared.topViewController() {
            viewController.handleLoadingView(isShow: isShow)
        }
    }
    
    
    /// Show alert Messeage
    ///
    /// - Parameter json: <#json description#>
    func showErrorMessage(json: JSONDictionary) {
        if let returnMess = json[API_RESPONSE_RETURN_MESSAGE] as? String {
            UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: returnMess, okTitle: "OK", cancelTitle: nil)
        }
    }
    
    
    // MARK: - Common function
    // Request post, Put, Delete
    public func requestWithEndPoint(host: String? = nil, endPoint: String, params: [String : Any], isShowLoadingView: Bool, httpType: HTTPMethodType, jsonData: Data? = nil) -> Promise<JSONDictionary> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var mutableURLRequest = self.postRequest!
        
        switch httpType {
        case .DELETE:
            mutableURLRequest = self.deleteRequest
            break
        case .POST:
            break
        case .PUT:
            mutableURLRequest = self.putRequest
            break
        }
        
        if isShowLoadingView {
            self.hanldeShowLoadingView(isShow: true)
        }
        
        var baseURL = self.baseURLString
        if let host_ = host {
            baseURL = host_
        }
        
        if let token = DataManager.shared.token {
            //Set Jwt Token
            mutableURLRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        return Promise<JSONDictionary> { seal in
            mutableURLRequest.url = URL(string: baseURL + endPoint)
            
            if let data = jsonData {
                mutableURLRequest.httpBody = data
            } else {
                mutableURLRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            }
            
            
            Alamofire.request(mutableURLRequest as URLRequest).responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if isShowLoadingView {
                    self.hanldeShowLoadingView(isShow: false)
                }
                
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                    print(error)
                    UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: self.getDisplayMessage(error: error), okTitle: "OK", cancelTitle: nil)
                    
                case .success(let responseObject):
                    if let responseDataDict = responseObject as? JSONDictionary {
                        
//                        guard let returnCode = responseDataDict[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
//                            if let returnMessage = responseDataDict[API_RESPONSE_RETURN_MESSAGE] as? String {
//                                UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: returnMessage, okTitle: "OK", cancelTitle: nil)
//                            }
//                            
//                            return
//                        }
                        
                        seal.fulfill(responseDataDict)
                    }
                    else {
                        
                        print("fail to parser data")
                        let error = NSError(domain: "BackendManager", code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: API_MESSAGE.OTHER_ERROR])
                        seal.reject(error)
                        UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: API_MESSAGE.DATA_FORMART_ERROR, okTitle: "OK", cancelTitle: nil)
                    }
                }
            }
        }
    }
    
    // Request get
    public func getDataWithEndPoint(host: String? = nil, endPoint: String, isShowLoadingView: Bool) -> Promise<JSONDictionary> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let mutableURLRequest = self.getRequest!
        
        if isShowLoadingView {
            self.hanldeShowLoadingView(isShow: true)
        }
        
        var baseURL = self.baseURLString
        if let host_ = host {
            baseURL = host_
        }
        
        if let token = DataManager.shared.token {
            //Set Jwt Token
            mutableURLRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        return Promise<JSONDictionary> { seal in
            mutableURLRequest.url = URL(string: baseURL + endPoint)
            
            Alamofire.request(mutableURLRequest as URLRequest).responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if isShowLoadingView {
                    self.hanldeShowLoadingView(isShow: false)
                }
                
                switch response.result {
                    
                case .failure(let error):
                    
                    seal.reject(error)
                    UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: self.getDisplayMessage(error: error), okTitle: "OK", cancelTitle: nil)
                    
                case .success(let responseObject):
                    
                    if let responseDataDict = responseObject as? JSONDictionary {
                        
                        seal.fulfill(responseDataDict)
                    }
                    else {
                        
                        print("fail to parser data")
                        let error = NSError(domain: "BackendManager", code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: API_MESSAGE.OTHER_ERROR])
                        seal.reject(error)
                        UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: API_MESSAGE.DATA_FORMART_ERROR, okTitle: "OK", cancelTitle: nil)
                    }
                }
            }
        }
    }
    
    // Upload Media
    func upload(type: FILE_TYPE_IMG, typeMedia: String, endPoint: String, imagesData: [Data], parameters: JSONDictionary, onCompletion: ((JSONDictionary?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = URL(string: self.baseURLString + endPoint)! /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data",
            "Authorization": "\(DataManager.shared.token ?? "")"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            var typeExpand: TYPE_UPLOAD_MEDIA_LENDING
            
            switch type {
            case .ALL:
                typeExpand = .NATIONALID_ALL
                break
            case .BACK:
                typeExpand = .NATIONALID_BACK
                break
            case .FRONT:
                typeExpand = .NATIONALID_FRONT
                break
            case .Optional:
                typeExpand = .OPTIONAL_MEDIA
                break
                
            }
            
            //let name = typeMedia + "_" + typeExpand.rawValue
            let fileName = typeMedia + "_" + typeExpand.rawValue + ".png"
            let mimetype = typeMedia + "/png"
            
            for data in imagesData {
                multipartFormData.append(data, withName: "files", fileName: fileName, mimeType: mimetype)
                
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")

                    switch response.result {
                    case .success(let responseObject):
                        if let responseDict = responseObject as? JSONDictionary {
                            onCompletion?(responseDict)
                        }
                        break
                        
                    case .failure(let error):
                        onError?(error)
                        break
                    }
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
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
        } else if err.code == NSURLErrorTimedOut  {
            errMessage = API_MESSAGE.Request_Timeout
        } else {
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
