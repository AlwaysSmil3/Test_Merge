//
//  APIClient+Payment.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/1/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    /// Create a transaction
    func createTransaction(from: Int, to: Int, paymentType: Int, note: String = "", amount: Double, type: Int, recept: String = "") -> Promise<APIResponseGeneral> {
        
        let params: JSONDictionary = [
            "loanId": DataManager.shared.loanID ?? 0,
            "from":from,
            "to":to,
            "paymentType":paymentType,
            "note": note,
            "amount":NSNumber(value: amount),
            "type":type,
            "receipt":recept
        ]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: EndPoint.Payment.Transaction, params: params, isShowLoadingView: true, httpType: HTTPMethodType.POST)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = APIResponseGeneral(object: data)
                        seal.fulfill(model)
                    }
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /// Get List Transaction
    func getTransactions() -> Promise<[Transaction]> {
        return Promise<[Transaction]> { seal in
            let uid = DataManager.shared.userID
            let endPoint = "\(APIService.LoanService)transactions/\(uid)"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    var array: [Transaction] = []
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Transaction(object: d)
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
    
    /// Get Collections - Các kỳ thu hồi nợ
    func getCollections() -> Promise<[CollectionPay]> {
        return Promise<[CollectionPay]> { seal in
            let loanId = DataManager.shared.loanID ?? 0
            let endPoint = "\(APIService.LoanService)loans/\(loanId)/collections"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    var array: [CollectionPay] = []
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = CollectionPay(object: d)
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
    
    /// Get Money Info
    func getPaymentMoneyInfo() -> Promise<PaymentInfoMoney> {
        let dateString = Date().toString(.custom(DATE_FORMATTER_WITH_SERVER), timeZone: .utc)
        let endPoint = "\(APIService.LoanService)loans/" + "\(DataManager.shared.loanID ?? 0)/" + "transactions/payment-info?paymentDate=" + dateString
        
        return Promise<PaymentInfoMoney> { seal in
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        if let message = json[API_RESPONSE_RETURN_MESSAGE] as? String {
                            UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "OK", cancelTitle: nil)
                        }
                        return
                    }
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = PaymentInfoMoney(object: data)
                        seal.fulfill(model)
                    }
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    func calculatorPay(amount: Int, term: Int, intRate: Int, disbursalDate: String) -> Promise<[CalculatorPay]> {
        return Promise<[CalculatorPay]> { seal in
            let endPoint = EndPoint.Payment.CalculatorPay + "?amount=\(amount)&term=\(term)&intRate=\(intRate)&disbursalDate=\(disbursalDate)"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    
                    var array: [CalculatorPay] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = CalculatorPay(object: d)
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
    
}
