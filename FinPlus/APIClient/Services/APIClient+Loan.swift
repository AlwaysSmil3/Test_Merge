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
    func getUserLoans() -> Promise<[BrowwerActiveLoan]> {
        return Promise<[BrowwerActiveLoan]> { seal in

            let uid = DataManager.shared.userID
            let endPoint = "\(uid)/" + EndPoint.Loan.Loans

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
        var endPoint = "users/" + "\(uid)/" + EndPoint.Loan.CreateLoans

        if httpType == .PUT {
            endPoint = "loans/" + "\(DataManager.shared.loanID ?? 0)"
        }

        return Promise<LoanResponseModel> { seal in
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: params, isShowLoadingView: isShowLoandingView, httpType: httpType, jsonData: dataAPI)
                .done { json in

                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        if let message = json[API_RESPONSE_RETURN_MESSAGE] as? String {
                            UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "OK", cancelTitle: nil, completion: { (status) in
                                if status {
                                    UIApplication.shared.topViewController()?.navigationController?.popViewController(animated: true)
                                }


                            })
                        }

                        return
                    }

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
    
    /* GET [Done]Y/c gửi lại OTP xác thực khoản vay
 
 
    */
    
    func getLoanOTP(loanID: Int32) -> Promise<APIResponseGeneral> {
        
        let endPoint = "loans/" + "\(loanID)/" + "otp"
        
        return Promise<APIResponseGeneral> { seal in
            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: true)
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
    
    
    
    
    

    func delLoan(loanID: Int32) -> Promise<APIResponseGeneral> {

        let endPoint = "loans/" + "\(loanID)/"

        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: [:], isShowLoadingView: true, httpType: .DELETE)
                .done { json in

                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }

    }

    /*
     API Invest A Loan
     */
    func investLoan(loanId: Int32, investorId: Int32, notes: Int32) -> Promise<InvestLoanBaseClass> {


        let endPoint = "loans/" + "\(loanId)/" + "notes"
        // fix wallet
        let walletId : Int32 = 1
        let params = [ "investorId" : investorId, "notes" : notes, "bankId" : walletId]

        return Promise<InvestLoanBaseClass> { seal in
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done { json in

                    let model = InvestLoanBaseClass(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }

    }

    /*
     API request OTP to Invest A Loan
     */

    func investLoanOTP(loanId: Int32, noteId: Int) -> Promise<APIResponseGeneral> {
        return Promise<APIResponseGeneral> { seal in
            let endPoint = "loans/" + "\(loanId)/" + "notes/" + "\(noteId)/" + "otp"
            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
    }

    func getOTPContract(loanID: Int32) -> Promise<APIResponseGeneral> {

        let endPoint = "loans/" + "\(loanID)/contract"

        return Promise<APIResponseGeneral> { seal in
            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
    }

    /*
     API confirm OTP to Invest A Loan
     */

    func confirmOTPInvestLoan(loanId: Int32, noteId: Int32, OTP: String) -> Promise<APIResponseGeneral> {
//        /loans/604/notes/3/otp
        let endPoint = "loans/" + "\(loanId)/" + "notes/" + "\(noteId)/" + "otp"
        let params = ["otp" : OTP]
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST).done{ json in
                let model = APIResponseGeneral(object: json)
                seal.fulfill(model)
                }.catch {
                    error in seal.reject(error)
            }
        }
    }

    func signContract(otp: String, loanID: Int32) -> Promise<APIResponseGeneral> {

        let endPoint = "loans/" + "\(loanID)/contract/otp"
        let params: JSONDictionary = [
            "otp": otp
        ]
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(host: hostLoan, endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
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
