//
//  APIClient+Loan.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

//let hostLoan = "https://dev-api.mony.vn/"//Loan Service
//let hostLoan = "http://192.168.104.70:31007/"//Loan Service
//let hostLoan = "https://b10644cc-7d66-4541-aa97-770206b05b43.mock.pstmn.io/" //Mock
//let hostLoan = "http://192.168.8.50:8079/"// - may thai

extension APIClient {
    
    /*
     GET Lấy danh sách các phí vay _ QUANNM
     */
    func getLoanBorrowerFee() -> Promise<[LoanBorrowerFee]> {
        
        return Promise<[LoanBorrowerFee]> { seal in
            getDataWithEndPoint(endPoint: EndPoint.Loan.LoanBorrowerFee, isShowLoadingView: false)
                .done { json in
                    var array: [LoanBorrowerFee] = []
                    
                    if let data = json["data"] as? JSONDictionary, let values = ListLoanBorrowerFee(JSON: data) {
                        array = values.list
                    }
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     GET Lấy danh sách các loại khoản vay
     */
    func getLoanCategories() -> Promise<[LoanCategories]> {
        
        return Promise<[LoanCategories]> { seal in
            getDataWithEndPoint(endPoint: EndPoint.Loan.LoanCategories, isShowLoadingView: false)
                .done { json in
                    var array: [LoanCategories] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        array = data.compactMap {LoanCategories(object: $0)}
                    }
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     GET Lấy danh sách tất cả các khoản vay
     */
    func getAllLoans() -> Promise<[BrowwerActiveLoan]> {
        return Promise<[BrowwerActiveLoan]> { seal in
            let endPoint = EndPoint.Loan.Loans
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    var array: [BrowwerActiveLoan] = []
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        array = data.compactMap {BrowwerActiveLoan(object: $0)}
                    }
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     GET Lấy danh sách các khoản vay có thể đầu tư
     */
    func getInvesableLoans() -> Promise<[BrowwerActiveLoan]> {
        return Promise<[BrowwerActiveLoan]> { seal in
            let endPoint = EndPoint.Loan.InvesableLoans
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    var array: [BrowwerActiveLoan] = []
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        array = data.compactMap {BrowwerActiveLoan(object: $0)}
                    }
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     GET Lấy danh sách khoản vay của người dùng
     */
    func getUserLoans(currentPage: Int, pageSize: Int = 30) -> Promise<JSONDictionary> {
        return Promise<JSONDictionary> { seal in
            
            let uid = DataManager.shared.userID
            let endPoint = "\(APIService.AccountService)users/\(uid)/" + "loans?page=\(currentPage)" + "&limit=\(pageSize)" + "&sort=createdDate.desc"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    //                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                    //                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                    //                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                    //                            if status {
                    //                                seal.fulfill([])
                    //                            }
                    //                        })
                    //                        return
                    //                    }
                    //                    var array: [BrowwerActiveLoan] = []
                    //
                    //                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                    //                        array = data.compactMap {BrowwerActiveLoan(object: $0)}
                    //                    }
                    seal.fulfill(json)
                }
                .catch { error in seal.reject(error)}
        }
    }
    
    /*
     POST Tạo một khoản vay mới
     PUT Cập nhật khoản vay
     */
    func loan(isShowLoandingView: Bool = true, httpType: HTTPMethodType = .POST) -> Promise<BrowwerActiveLoan> {
        let params = ["": ""]
        let loanInfo = DataManager.shared.loanInfo
        let loanInfoData = try? JSONEncoder().encode(loanInfo)
        var dataAPI = Data()
        
        if let data = loanInfoData {
            dataAPI = data
        }
        
        //let uid = DataManager.shared.userID
        var endPoint = EndPoint.Loan.CreateLoans
        
        if httpType == .PUT {
            endPoint = "\(APIService.LoanService)loans/" + "\(DataManager.shared.loanID ?? 0)"
        }
        
        return Promise<BrowwerActiveLoan> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: isShowLoandingView, httpType: httpType, jsonData: dataAPI)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                UIApplication.shared.topViewController()?.navigationController?.popViewController(animated: true)
                            }
                        })
                        return
                    }
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerActiveLoan(object: data)
                        seal.fulfill(model)
                    }
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     POST Xác thực khoản vay qua OTP
     */
    func loanVerify(otp: String, loanID: Int32) -> Promise<APIResponseGeneral> {
        let endPoint = "loans/" + "\(loanID)/" + "otp"
        let params = ["otp": otp]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                
                            }
                        })
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
    
    /// Upload contact
    ///
    /// - Parameter list: <#list description#>
    /// - Returns: <#return value description#>
    func uploadContacts(list: ContactParamsList) -> Promise<APIResponseGeneral> {
        let endPoint = "\(APIService.LoanService)loans/contacts/" + "\(DataManager.shared.userID)"
        let params = ["": ""]
        let contactData = try? JSONEncoder().encode(list)
        var dataAPI = Data()
        
        if let data = contactData {
            dataAPI = data
        }
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST, jsonData: dataAPI)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                
                            }
                        })
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
    
    /*
     GET [Done]Y/c gửi lại OTP xác thực khoản vay
     */
    
    func getLoanOTP(loanID: Int32) -> Promise<APIResponseGeneral> {
        
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanID)/" + "otp"
        
        return Promise<APIResponseGeneral> { seal in
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                
                            }
                        })
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
    
    func delLoan(loanID: Int32) -> Promise<APIResponseGeneral> {
        
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanID)"
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: [:], isShowLoadingView: true, httpType: .DELETE)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     API Invest A Loan
     */
    func investLoan(loanId: Int32, investorId: Int32, notes: Int32) -> Promise<InvestLoanBaseClass> {
        
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanId)/" + "notes"
        // fix wallet
        let walletId : Int32 = 1
        let params = [ "investorId" : investorId, "notes" : notes, "bankId" : walletId]
        
        return Promise<InvestLoanBaseClass> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done { json in
                    let model = InvestLoanBaseClass(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     API request OTP to Invest A Loan
     */
    
    func investLoanOTP(loanId: Int32, noteId: Int) -> Promise<APIResponseGeneral> {
        return Promise<APIResponseGeneral> { seal in
            let endPoint = "\(APIService.LoanService)loans/" + "\(loanId)/" + "notes/" + "\(noteId)/" + "otp"
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    func getOTPContract(loanID: Int32) -> Promise<APIResponseGeneral> {
        
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanID)/contract"
        
        return Promise<APIResponseGeneral> { seal in
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                
                            }
                        })
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
    
    /*
     API confirm OTP to Invest A Loan
     */
    
    func confirmOTPInvestLoan(loanId: Int32, noteId: Int32, OTP: String) -> Promise<APIResponseGeneral> {
        //        /loans/604/notes/3/otp
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanId)/" + "notes/" + "\(noteId)/" + "otp"
        let params = ["otp" : OTP]
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch {
                    error in seal.reject(error)
            }
        }
    }
    
    func signContract(otp: String, loanID: Int32) -> Promise<APIResponseGeneral> {
        
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanID)/contract/otp"
        let params: JSONDictionary = [
            "otp": otp,
            "longitude": DataManager.shared.currentLocation?.longitude ?? 0,
            "latitude": DataManager.shared.currentLocation?.latitude ?? 0
        ]
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                
                            }
                        })
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
    
    /// lấy hợp đồng
    ///
    /// - Parameter loanID: <#loanID description#>
    /// - Returns: <#return value description#>
    func getContractWhenSign() -> Promise<APIResponseGeneral> {
        
        let endPoint = "\(APIService.LoanService)loans/" + "\(DataManager.shared.loanID ?? 0)/contract/sign"
        let params: JSONDictionary = [:]
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: false, httpType: .POST)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                
                            }
                        })
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
    
}
