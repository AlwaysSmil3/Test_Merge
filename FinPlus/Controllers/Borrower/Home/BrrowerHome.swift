//
//  BrrowerHome.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/30/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol BrowwerHomeDelegate {
    
    func updateInfo(status: STATUS_LOAN)
    
}

class BrrowerHome: UIView {
    
    //DRAFT: 0 # Màn hình H.3
    @IBOutlet var viewH3: UIView!
    
    // "WAITING_FOR_APPROVAL": 1, // H.4
    @IBOutlet var viewH4: UIView!
    
    //"PENDING": 2, // H.5
    @IBOutlet var viewH5: UIView!
    
    //"ACCEPTED": 3, // H.6 -> H.9
    @IBOutlet var viewH6: UIView!
    
    @IBOutlet var lblNumberPhone: [UILabel]!
    @IBOutlet var lblCreatedTime: [UILabel]!
    @IBOutlet var lblAmountLoan: [UILabel]!
    @IBOutlet var lblTermLoan: [UILabel]!
    @IBOutlet var lblPercentFee: [UILabel]!
    @IBOutlet var lblAmountPayMounth: [UILabel]!
    @IBOutlet var lblServiceFee: [UILabel]!
    @IBOutlet var lblLoanStatus: [UILabel]!
    
    @IBOutlet var lblUpdateInfo: UILabel!
    
    fileprivate var containerView: UIView!
    fileprivate let nibName = "BrrowerHome"
    
    //Loan status
    var loanStatus: STATUS_LOAN = .DRAFT
    
    var delegate: BrowwerHomeDelegate?
    
    var loanInfo: BrowwerActiveLoan? {
        didSet {
            self.updateUI()
            self.setupView()
        }
    }
    
    // MARK: - init
    convenience init(frame: CGRect, number: Int) {
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        
    }
    
    func xibSetup() {
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(containerView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupView() {
        guard let loan = self.loanInfo else { return }
        
        switch loan.status! {
        case 0:
            //DRAFT: 0 # Màn hình H.3
            self.loanStatus = .DRAFT
            
            break
        case 1:
            //"WAITING_FOR_APPROVAL": 1, // H.4
            self.containerView.addSubview(self.viewH4)
            self.loanStatus = .WAITING_FOR_APPROVAL
            
            break
        case 2:
            //"PENDING": 2, // H.5
            self.containerView.addSubview(self.viewH5)
            self.loanStatus = .PENDING
            
            break
        case 3:
            //"ACCEPTED": 3, // H.6 -> H.9
            self.containerView.addSubview(self.viewH6)
            self.loanStatus = .ACCEPTED
            
            break
        default:
            break
        }
    }
    
    private func updateUI() {
        
        if let data = DataManager.shared.browwerInfo {
            for lblPhone in lblNumberPhone {
                lblPhone.text = "\(data.phoneNumber!)"
            }
        }
        
        guard let loan = self.loanInfo else { return }
        
        for time in lblCreatedTime {
            // ngày taọ Đơn vay
            time.text = loan.createdTime!
        }
        
        for amount in lblAmountLoan {
            // Số tiền vay
            amount.text = FinPlusHelper.formatDisplayCurrency(Double(loan.amount!)) + " VND"
        }
        
        for term in lblTermLoan {
            // Kỳ hạn vay
            term.text = "\(loan.term!)" + " Ngày"
        }
        
        for percentFee in lblPercentFee {
            // phần trăm lãi xuất
            percentFee.text = "x%"
        }
        
        for amountPayMounth in lblAmountPayMounth {
            // Số tiền phải trả hàng tháng
            amountPayMounth.text = "x VND"
        }
        
        if let version = DataManager.shared.version {
            for serviceFee in lblServiceFee {
                serviceFee.text = FinPlusHelper.formatDisplayCurrency(Double((Int32(version.serviceFee!) * loan.amount!) / 100)) + " VND"
            }
        }
        
    }
    
    //MARK: Actions
    
    @IBAction func btnContinueUpdateInfoTapped(_ sender: Any) {
        delegate?.updateInfo(status: self.loanStatus)
        
    }
    
    
    
    
}
