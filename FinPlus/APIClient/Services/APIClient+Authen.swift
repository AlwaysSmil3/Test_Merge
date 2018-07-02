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
     0966003631
     
     Số điện thoại đăng ký
     uuid
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
     
     Device unique id
     deviceType
     0
     
     0: iOS, 1 : android
     password
     xxxxxxxxxxxxxxxxxxxxxxx
     
     Optional: Mật khẩu của người dùng

     */
    func authentication(phoneNumber: String, pass: String = "") -> Promise<AuthenticationBase> {
        
        let id = UIDevice.current.identifierForVendor!.uuidString
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "uuid": id,
            "deviceType": API_DEVICE_TYPE_OS,
            "password": pass
        ]
        
        return Promise<AuthenticationBase> { seal in
            requestWithEndPoint(endPoint: EndPoint.Authen.Authen, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    let model = AuthenticationBase(object: json)
                    seal.fulfill(model)
                }
                .catch{ error in
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
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "otp": otp,
        ]
        
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
    func updateInfoFromFacebook(phoneNumber: String, pass: String, accountType: Int, accessToken: String, avatar: String, displayName: String, investOtherInfo: InvestorRegisterModel? = nil) -> Promise<BrowwerInfo> {
        
        var params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "password": pass,
            "accountType": accountType,
            "accessToken": accessToken,
            "avatar": avatar,
            "displayName": displayName
        ]
        
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
        
        let params: JSONDictionary = [
            "token": token
        ]
        
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
    
    
    
    
    
}
