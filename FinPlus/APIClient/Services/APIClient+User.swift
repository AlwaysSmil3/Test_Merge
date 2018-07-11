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
                    print(json)
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        
                        if let activeLoan = data["activeLoan"] as? JSONDictionary, let missingData = activeLoan["missingData"] as? JSONDictionary {
                            DataManager.shared.missingLoanData = BrowwerActiveLoan(object: missingData)
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
            let endPoint = "users/" + "\(uID)" + "/push-token"
            
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
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in

                        var array: [AccountBank] = []
                        
                        if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                            
                            for d in data {
                                let model1 = AccountBank(object: d)
                                array.append(model1)
                            }
                            
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
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .DELETE)
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
    func forgetPassword(phoneNumber: String, nationalId: String = "") -> Promise<OTP> {
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "nationalId": nationalId,
            ]
        
        return Promise<OTP> { seal in
            requestWithEndPoint(endPoint: EndPoint.User.ForgetPassword, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = OTP(object: json)
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
    func forgetPasswordOTP(phoneNumber: String, otp: String) -> Promise<OTP> {
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "otp": otp,
            ]
        
        return Promise<OTP> { seal in
            requestWithEndPoint(endPoint: EndPoint.User.ForgetPasswordOTP, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = OTP(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
    }
    
    
    
    
}
