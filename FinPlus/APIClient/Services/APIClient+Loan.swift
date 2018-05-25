//
//  APIClient+Loan.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
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
    func loan()  -> Promise<APIResponseGeneral> {
        
        let loanInfo = DataManager.shared.loanInfo

        
        var params: JSONDictionary = [
            "": ""
        ]
        
        let loanInfoData = try? JSONEncoder().encode(loanInfo)
        
        var dataAPI = Data()
        
        if let data = loanInfoData {
            dataAPI = data
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let json = json as? JSONDictionary {
                params = json
                print("Person JSON:\n" + String(describing: json) + "\n")

            }
        }
        
        
        let uid = DataManager.shared.userID
        let endPoint = "\(uid)/" + EndPoint.Loan.Loan
        
        return Promise { fullFill, reject in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST, jsonData: dataAPI)
                .then { json -> Void in
                    print("\(json)")
                    let model = APIResponseGeneral(object: json)
                    fullFill(model)
                }
                .catch{ error in
                    reject(error)
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}
