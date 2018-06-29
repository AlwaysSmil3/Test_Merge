//
//  APIClient+Loan.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

let hostLoan = "http://192.168.104.70:31007/"//Loan Service
//let hostLoan = "https://b10644cc-7d66-4541-aa97-770206b05b43.mock.pstmn.io/" //Mock

extension APIClient {
    
    /* GET Lấy danh sách các loại khoản vay
     
     */
    
    func getLoanCategories() -> Promise<[LoanCategories]> {
        
        return Promise<[LoanCategories]> { seal in
            getDataWithEndPoint(host: hostLoan, endPoint: EndPoint.Loan.LoanCategories, isShowLoadingView: false)
                .done { json in
                    
                    var array: [LoanCategories] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let loan = LoanCategories(object: d)
                            array.append(loan)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in seal.reject(error)}
        }
        
        
    }

    /*
     GET Lấy danh sách tất cả các khoản vay
    */
    func getAllLoans() -> Promise<[BrowwerActiveLoan]> {
        return Promise<[BrowwerActiveLoan]> { seal in
            let endPoint = EndPoint.Loan.Loans

            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    var array: [BrowwerActiveLoan] = []

                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = BrowwerActiveLoan(object: d)
                            array.append(model1)
                        }
                    }
                    seal.fulfill(array)

                }
                .catch { error in seal.reject(error)}
        }
    }

    /*
     GET Lấy danh sách các khoản vay có thể đầu tư
     */
    func getInvesableLoans() -> Promise<[BrowwerActiveLoan]> {
        return Promise<[BrowwerActiveLoan]> { seal in
            let endPoint = EndPoint.Loan.InvesableLoans

            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    var array: [BrowwerActiveLoan] = []
                    print(endPoint)
                    print("jsondata: \(json)")
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = BrowwerActiveLoan(object: d)
                            array.append(model1)
                        }
                    } else if let data = json[API_RESPONSE_RETURN_DATA] as? [BrowwerActiveLoan] {
                        print("123")
                    } else {
                        print(json[API_RESPONSE_RETURN_DATA].self)
                    }
                    seal.fulfill(array)

                }
                .catch { error in seal.reject(error)}
        }
    }
    
    /*
     GET Lấy danh sách khoản vay của người dùng
        
     */
    func getLoans() -> Promise<APIResponseGeneral> {
        return Promise<APIResponseGeneral> { seal in
            
            let uid = DataManager.shared.userID
            let endPoint = "\(uid)/" + EndPoint.Loan.Loans
            
            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
    }
    
    /* POST Tạo một khoản vay mới
     PUT Cập nhật khoản vay
     
     */
    func loan(isShowLoandingView: Bool = true, httpType: HTTPMethodType = .POST) -> Promise<LoanResponseModel> {
        let params: JSONDictionary = [
            "": ""
        ]
        
        let loanInfo = DataManager.shared.loanInfo
        let loanInfoData = try? JSONEncoder().encode(loanInfo)
        
        var dataAPI = Data()
        
        if let data = loanInfoData {
            dataAPI = data
        }
        
        let uid = DataManager.shared.userID
        var endPoint = "users/" + "\(uid)/" + EndPoint.Loan.Loans
        
        if httpType == .PUT {
            endPoint = "loans/" + "\(DataManager.shared.loanID ?? 0)"
        }
        
        return Promise<LoanResponseModel> { seal in
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: params, isShowLoadingView: isShowLoandingView, httpType: httpType, jsonData: dataAPI)
                .done { json in
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = LoanResponseModel(object: data)
                        seal.fulfill(model)
                    }
                }
                .catch{ error in
                    seal.reject(error)
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
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done { json in
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
        
    }
    
    
    
    
    
}
