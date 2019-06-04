//
//  APIClient+Authen.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/9/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    /* Đăng ký số điện thoại mới
     phoneNumber
     
     
     Số điện thoại đăng ký
     uuid
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
     
     Device unique id
     deviceType
     0
     
     1: iOS, 0 : android
     password
     xxxxxxxxxxxxxxxxxxxxxxx
     
     Optional: Mật khẩu của người dùng

     */
    func authentication(phoneNumber: String, pass: String = "") -> Promise<AuthenticationBase> {
        
        let id = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        var params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "uuid": id,
            "deviceType": API_DEVICE_TYPE_OS,
            "password": pass,
            "deviceName": UIDevice.modelName,
            "appType": 0
        ]
        
        if pass.count > 0 {
            params = [
            "phoneNumber": phoneNumber,
            "uuid": id,
            "deviceType": API_DEVICE_TYPE_OS,
            "password": pass,
            "appType": 0,
            "deviceName": UIDevice.modelName,
            "deviceEmail": "",
            ]
        }
        
        return Promise<AuthenticationBase> { seal in
            requestWithEndPoint(endPoint: EndPoint.Authen.Authen, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = AuthenticationBase(object: json)
                    
                    if let data = model.data, let token = data.jwtToken {
                        DataManager.shared.token = token
                        print("token user : \(token)")
                    }
                    
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    
    /*  Xác thực số điện thoại vừa đăng ký
     
     phoneNumber
     0966003631
     
     Số điện thoại sử dụng để đăng ký
     otp
     xxxxxx
     
     Mã OTP 6 số
     */
    func verifyOTPAuthen(phoneNumber: String, otp: String) -> Promise<OTP> {
        
        let params = ["phoneNumber": phoneNumber, "otp": otp]
        
        return Promise<OTP> { seal in
            requestWithEndPoint(endPoint: EndPoint.Authen.verifyOTP, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = OTP(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*  Cập nhật thông tin người dùng lần đầu đăng ký SĐT
     
     password
     xxxxxxxxxxxxxxxx
     
     Password người dùng nhập vào
     accountType
     1
     
     Loại tài khoản: 0: Borrower 1: Investor
     accessToken
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
     
     Facebook access token
     phoneNumber
     0966003631
     
     SĐT đăng ký
     avatar
     https://xxxxxxxxxxxxxxx
     
     Link ảnh avatar facebook
     displayName
     P2P Borrower
     
     Tên hiển thị trên facebook
     */
    func updateInfoFromFacebook(phoneNumber: String, pass: String? = nil, accountType: Int? = 0, accessToken: String? = nil, avatar: String? = nil, displayName: String? = nil, investOtherInfo: InvestorRegisterModel? = nil, facebookId: String? = nil) -> Promise<BrowwerInfo> {
        
        var params: JSONDictionary = [:]
        
        if let pas = pass {
            params = [
                "phoneNumber": phoneNumber,
                "password": pas,
                //"accessToken": accessToken,
                //"avatar": avatar,
                //"displayName": displayName
            ]
            
            if let type = accountType {
                params = [
                    "phoneNumber": phoneNumber,
                    "password": pas,
                    "accountType": type,
                    //"accessToken": accessToken,
                    //"avatar": avatar,
                    //"displayName": displayName
                ]
            }
        }

        
        if let accessToken = accessToken {
            params = [
                "phoneNumber": phoneNumber,
//                "password": pass,
                "accountType": 0,
                "accessToken": accessToken,
                "avatar": avatar ?? "",
                "displayName": displayName ?? "",
                "facebookId": facebookId ?? ""
            ]
        }
        
        return Promise<BrowwerInfo> { seal in
            
            requestWithEndPoint(endPoint: EndPoint.Authen.Authen, params: params, isShowLoadingView: true, httpType: HTTPMethodType.PUT)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        seal.fulfill(model)
                    }
                    
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    
    /// Update in cho đăng ký là nhà đầu tư
    ///
    /// - Parameter investInfo: <#investInfo description#>
    /// - Returns: <#return value description#>
    func updateInfoForInvestor(investInfo: InvestorRegisterModel) -> Promise<BrowwerInfo> {
        
        let params: JSONDictionary = [
            "" : ""
        ]
        
        let investInfoData = try? JSONEncoder().encode(investInfo)
        
        var dataAPI = Data()
        if let data = investInfoData {
            dataAPI = data
        }
        
        return Promise<BrowwerInfo> { seal in
            
            requestWithEndPoint(endPoint: EndPoint.Authen.Authen, params: params, isShowLoadingView: true, httpType: HTTPMethodType.PUT, jsonData: dataAPI)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        seal.fulfill(model)
                    }
                    
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    
    /*
     POST [Done] Đăng xuất ứng dụng điện thoại
     HEADERS
     Content-Type
     application/json
     BODY
     
     {
     "token": "xxxxxxxxxxxxxx"
     }
     

     */
    func logOut() -> Promise<APIResponseGeneral> {
        
        let token = DataManager.shared.pushNotificationToken ?? ""
        
        let params = ["token": token]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: EndPoint.Authen.Logout, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    
    /// gui yeu cau gửi lại otp khi Authen
    ///
    /// - Returns: <#return value description#>
    func getAuthenOTP() -> Promise<APIResponseGeneral> {
        
        let endPoint = EndPoint.Authen.resendOTPAuthen + DataManager.shared.currentAccount
        
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
