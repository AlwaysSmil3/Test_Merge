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
    func authentication(phoneNumber: String, pass: String = "") -> Promise<APIResponseGeneral> {
        
        let id = UUID().uuidString
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "uuid": id,
            "deviceType": API_DEVICE_TYPE_OS,
            "password": pass
        ]
        
        return Promise { fullFill, reject in
            requestWithEndPoint(endPoint: EndPoint.Authen.Authen, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .then { json -> Void in
                    
                    let model = APIResponseGeneral(object: json)
                    fullFill(model)
                }
                .catch{ error in
                    reject(error)
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
    func verifyOTPAuthen(phoneNumber: String, otp: String) -> Promise<VerifyAuthenData> {
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "otp": otp,
        ]
        
        return Promise { fullFill, reject in
            requestWithEndPoint(endPoint: EndPoint.Authen.verifyOTP, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .then { json -> Void in
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = VerifyAuthenData(object: data)
                        fullFill(model)
                    }
                }
                .catch { error in
                    reject(error)
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
    func updateInfoFromFacebook(phoneNumber: String, pass: String, accountType: Int, accessToken: String, avatar: String, displayName: String) -> Promise<BrowwerInfo> {
        
        let params: JSONDictionary = [
            "phoneNumber": phoneNumber,
            "password": pass,
            "accountType": accountType,
            "accessToken": accessToken,
            "avatar": avatar,
            "displayName": displayName
        ]
        
        return Promise { fullFill, reject in
            
            requestWithEndPoint(endPoint: EndPoint.Authen.Authen, params: params, isShowLoadingView: true, httpType: HTTPMethodType.PUT)
                .then { json -> Void in
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        fullFill(model)
                    }
                    
                }
                .catch(execute: { (error) in
                    reject(error)
                })
        }
        
    }
    
    
    
    
}
