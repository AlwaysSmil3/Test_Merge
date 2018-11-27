//
//  APIClient+User.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/17/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    /* Lấy thông tin người dùng
     
     */
    func getUserInfo(uId: Int32) -> Promise<BrowwerInfo> {
        
        return Promise<BrowwerInfo> { seal in
            let endPoint = EndPoint.User.User + "\(uId)"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    //print(json)
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        
                        if let phone = model.phoneNumber, phone.count > 0, phone != DataManager.shared.currentAccount {
                            DataManager.shared.setCurrentAccount(account: phone)
                        }
                        
                        if let activeLoan = model.activeLoan,let status = activeLoan.status, status == STATUS_LOAN.SALE_PENDING.rawValue || status == STATUS_LOAN.RISK_PENDING.rawValue {
                            if let activeLoan = data["activeLoan"] as? JSONDictionary, let missingData = activeLoan["missingData"] as? JSONDictionary {
                                
                                DataManager.shared.browwerInfo = model
                                
                                if let optionalData = missingData["optionalText"] as? JSONDictionary {
                                    DataManager.shared.missingOptionalText = optionalData
                                }
                                
                                if let optionalMedia = missingData["optionalMedia"] as? [String: Any] {
                                    DataManager.shared.missingOptionalMedia = optionalMedia
                                }
                                
                                if let userInfo = missingData["userInfo"] as? JSONDictionary, let relationShip = userInfo["relationships"] as? [String: Any] {
                                    DataManager.shared.missingRelationsShip = relationShip
                                }
                                
                                
                                DataManager.shared.missingLoanDataDictionary = missingData
                                DataManager.shared.missingLoanData = BrowwerActiveLoan(object: missingData)
                                
                            } else {
                                DataManager.shared.clearMissingLoanData()
                            }
                        } else {
                            DataManager.shared.clearMissingLoanData()
                        }

                        seal.fulfill(model)
                    }
                }
                .catch { error in
                    seal.reject(error)
                }
            
        }
        
    }
    
    /*
     
     PUT [Done] Cập push notification token
     HEADERS
     Content-Type
     application/json
     PATH VARIABLES
     uid
     
     Mã khách hàng của Fin+
     BODY
     
     {
     "token":"xxxxxxxxxxxxxxxxxxxxxxx"
     }
     

     */
    func pushNotificationToken() -> Promise<APIResponseGeneral> {
        let token = DataManager.shared.pushNotificationToken ?? ""
        
        let params: JSONDictionary = [
            "token": token
        ]
        
        return Promise<APIResponseGeneral> { seal in
            
            let uID = DataManager.shared.userID
            let endPoint = "\(APIService.AccountService)users/" + "\(uID)" + "/push-token"
            
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: false, httpType: HTTPMethodType.PUT)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
        
    }
    
    /* Lấy danh sách tài khoản ngân hàng
     
     */
    func getListBank(uId: Int32) -> Promise<[AccountBank]> {
        
        return Promise<[AccountBank]> { seal in
            let endPoint = EndPoint.User.User + "\(uId)/bank-account"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in

                        var array: [AccountBank] = []
                        
                        if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                            array = data.compactMap{ AccountBank(object: $0) }
                            
                        }
                        
                        seal.fulfill(array)
            
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
    }
    
    /* Thêm tài khoản ngân hàng
     
     */
    func addNewBank(uId: Int32, params: JSONDictionary) -> Promise<APIResponseGeneral> {
        
        let endPoint = EndPoint.User.User + "\(uId)/bank-account"

        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(host: Host.productURL, endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)

                }
                .catch { error in seal.reject(error)}
        }
    }
    
    /* Xóa tài khoản ngân hàng
     
     */
    func delBank(uId: Int32, params: JSONDictionary) -> Promise<APIResponseGeneral> {
        
        let endPoint = EndPoint.User.User + "\(uId)/bank-account"
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .DELETE)
                .done { json in
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
    }
    
    
    /// forget password
    ///
    /// - Parameters:
    ///   - phoneNumber: <#phoneNumber description#>
    ///   - nationalId: <#nationalId description#>
    /// - Returns: <#return value description#>
    func forgetPassword(phoneNumber: String, nationalId: String = "") -> Promise<APIResponseGeneral> {
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "nationalId": nationalId,
            ]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: EndPoint.User.ForgetPassword, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
    }
    
    
    /// Quen pass verify otp
    ///
    /// - Parameters:
    ///   - phoneNumber: <#phoneNumber description#>
    ///   - otp: <#otp description#>
    /// - Returns: <#return value description#>
    func forgetPasswordOTP(phoneNumber: String, otp: String) -> Promise<APIResponseGeneral> {
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "otp": otp,
            ]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: EndPoint.User.ForgetPasswordOTP, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
    }
    
    
    /// Cap nhat pass moi khi quen pass
    ///
    /// - Parameters:
    ///   - phoneNumber: <#phoneNumber description#>
    ///   - pwd: <#pwd description#>
    /// - Returns: <#return value description#>
    func forgetPasswordNewPass(phoneNumber: String, pwd: String) -> Promise<APIResponseGeneral> {
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "password": pwd,
            ]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: EndPoint.User.ForgetPasswordNewPass, params: params, isShowLoadingView: true, httpType: HTTPMethodType.PUT)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
    }
    
    
    /// Đổi password
    ///
    /// - Parameters:
    ///   - phoneNumber: <#phoneNumber description#>
    ///   - pwd: <#pwd description#>
    /// - Returns: <#return value description#>
    func changePassword(oldPass: String, newPass: String) -> Promise<APIResponseGeneral> {
        
        let params: JSONDictionary = [
            "oldPassword": oldPass,
            "newPassword": newPass,
            ]
        
        let uID = DataManager.shared.userID
        let endPoint = "\(APIService.AccountService)users/" + "\(uID)" + "/change-password"
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: HTTPMethodType.PUT)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        if let message = json[API_RESPONSE_RETURN_MESSAGE] as? String {
                            UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "OK", cancelTitle: nil, completion: { (status) in
                                if status {
                                }
                                
                            })
                        }
                        
                        return
                    }
                    
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
    }
    
    
    /// gui lai otp mục quên mật khẩu
    ///
    /// - Returns: <#return value description#>
    func getForgetPasswordOTP() -> Promise<APIResponseGeneral> {
        
        let endPoint = EndPoint.User.GetOTPForgetPassword
        
        return Promise<APIResponseGeneral> { seal in
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        if let message = json[API_RESPONSE_RETURN_MESSAGE] as? String {
                            UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "OK", cancelTitle: nil, completion: { (status) in
                                if status {
                                }
                                
                            })
                        }
                        
                        return
                    }
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
        
    }
    
    
    
    
}
