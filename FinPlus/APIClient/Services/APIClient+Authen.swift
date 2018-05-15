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
            postRequestWithEndPoint(endPoint: EndPoint.Authen.Authen, params: params, isShowLoadingView: true)
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
            postRequestWithEndPoint(endPoint: EndPoint.Authen.verifyOTP, params: params, isShowLoadingView: true)
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
    
    
    
    
}
