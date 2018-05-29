//
//  APIClient+Loan.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    /* GET Lấy danh sách các loại khoản vay
     
     */
    func getLoanCategories() -> Promise<[LoanCategories]> {
        
        return Promise { fullFill, reject in
            getDataWithEndPoint(endPoint: EndPoint.Loan.LoanCategories, isShowLoadingView: false)
                .then { json -> Void in
                    
                    var array: [LoanCategories] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let loan = LoanCategories(object: d)
                            array.append(loan)
                        }
                    }
                    
                    fullFill(array)
                }
                .catch { error in reject(error)}
        }
        
        
    }
    
    /*
     GET Lấy danh sách khoản vay của người dùng
     
     */
    func getLoans() -> Promise<APIResponseGeneral> {
        return Promise { fullFill, reject in
            
            let uid = DataManager.shared.userID
            let endPoint = "\(uid)/" + EndPoint.Loan.Loans
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .then { json -> Void in
                    let model = APIResponseGeneral(object: json)
                    fullFill(model)
                }
                .catch { error in reject(error)}
        }
    }
    
    /* POST Tạo một khoản vay mới
     
     */
    func loan(isShowLoandingView: Bool = true) -> Promise<LoanResponseModel> {
        let params: JSONDictionary = [
            "": ""
        ]
        
        let loanInfo = DataManager.shared.loanInfo
        let loanInfoData = try? JSONEncoder().encode(loanInfo)
        
        var dataAPI = Data()
        
        if let data = loanInfoData {
            dataAPI = data
//            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//            if let json = json {
//                print("Person JSON:\n" + String(describing: json) + "\n")
//
//            }
        }
        
        let uid = DataManager.shared.userID
        let endPoint = "\(uid)/" + EndPoint.Loan.Loans
        
        return Promise { fullFill, reject in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: isShowLoandingView, httpType: HTTPMethodType.POST, jsonData: dataAPI)
                .then { json -> Void in
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = LoanResponseModel(object: data)
                        fullFill(model)
                    }
                }
                .catch{ error in
                    reject(error)
            }
        }
    }
    
    /* POST Xác thực khoản vay qua OTP
 
     */
    
    func loanVerify(otp: String, loanID: Int32) -> Promise<APIResponseGeneral> {
        
        let endPoint = "loans/" + "\(loanID)/" + "otp"
        let params: JSONDictionary = [
            "otp": otp
        ]
        
        return Promise { fullFill, reject in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .then { json -> Void in
                    
                    let model = APIResponseGeneral(object: json)
                    fullFill(model)
                }
                .catch { error in reject(error)}
        }
        
    }
    
    
    
    
    
}
