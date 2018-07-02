//
//  InvestDetailFirstTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData
import SDWebImage


class InvestDetailFirstTableViewCell: UITableViewCell {
    var cellData : BrowwerActiveLoan!
    var reliType : LoanReliability!
    var loanCategories : [LoanCategories] = [LoanCategories]()

    @IBOutlet weak var alreadyAmountCircleProgressView: UICircularProgressRingView!
    @IBOutlet weak var realibilityCircleLb: UILabel!
    @IBOutlet weak var realibilityNameLb: UILabel!
    @IBOutlet weak var realibilityDesLb: UILabel!

    @IBOutlet weak var loanTypeImg: UIImageView!
    @IBOutlet weak var loanTypeNameLb: UILabel!
    @IBOutlet weak var loanExpireMonth: UILabel!

    @IBOutlet weak var interestCircleLb: UILabel!
    @IBOutlet weak var interestNameLb: UILabel!
    @IBOutlet weak var interestDes: UILabel!

    @IBOutlet weak var alreadyProgress: UILabel!
    @IBOutlet weak var alreadyNameLb: UILabel!
    @IBOutlet weak var alreadyDesLb: UILabel!
    // CoreData
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        return appDelegate.managedObjectContext
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.realibilityCircleLb.clipsToBounds = true
        self.realibilityCircleLb.layer.cornerRadius = 22

        self.interestCircleLb.clipsToBounds = true
        self.interestCircleLb.layer.cornerRadius = 22

        self.interestCircleLb.backgroundColor = UIColor(hexString: "#F7F7F7")
    }

    func updateCellView() {
        // first block
        self.realibilityCircleLb.layer.cornerRadius = 22
        self.interestCircleLb.layer.cornerRadius = 22

        self.realibilityCircleLb.text = cellData.grade ?? "A1"

        var reliType : LoanReliability!
        switch realibilityCircleLb.text {
        case "A1":
            reliType = LoanReliability.A1
        case "A2":
            reliType = LoanReliability.A2
        case "A3":
            reliType = LoanReliability.A3
        case "B1":
            reliType = LoanReliability.B1
        case "B2":
            reliType = LoanReliability.B2
        case "B3":
            reliType = LoanReliability.B3
        case "C1":
            reliType = LoanReliability.C1
        case "C2":
            reliType = LoanReliability.C2
        case "C3":
            reliType = LoanReliability.C3
        case "D":
            reliType = LoanReliability.D
        default:
            reliType = LoanReliability.A1

        }
        self.realibilityCircleLb.backgroundColor = reliType.color
        self.realibilityNameLb.text = "Tín dụng hạng " + reliType.rawValue
        self.realibilityDesLb.text = "Có độ an toàn cao nhất nhưng lãi suất không cao"
        // second block
        print(self.loanCategories.count)
        
        if self.loanCategories.count > 0 {
            for loanCategoryDetail in self.loanCategories {
                if (loanCategoryDetail.id! == cellData.loanCategoryId) {
                    self.loanTypeNameLb.text = loanCategoryDetail.title
                }
            }
        }
//        self.loanTypeNameLb.text = cellData.name
        var termStr = ""
        if cellData.loanCategoryId == 1 {
            termStr = "Thời hạn \(cellData.term!) ngày"
        } else {
            termStr = "Thời hạn \(cellData.term!/30) tháng"
        }
        self.loanExpireMonth.text = termStr
        // show loan type image
            if self.loanCategories.count > 0 {
                for loanCategoryDetail in self.loanCategories {
                    if (loanCategoryDetail.id! == cellData.loanCategoryId) {
                        if let imageUrl = loanCategoryDetail.imageUrl {
                            let urlString = hostLoan + imageUrl
                            let url = URL(string: urlString)
                            self.loanTypeImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic_homeBrower_group1"))
                        }
                    }
                }
        }
        // third block
        // add attribute string
        var rate : Float = 20
        if let temp = cellData.inRate {
            rate = temp
        }
        let interestCircleStr = rate.toString() + "\n%/năm"
        let myRange = NSRange(location: interestCircleStr.length() - 5, length: 5)
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: interestCircleStr)
        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "SF Pro Display", size: 8)!, range: myRange)
        self.interestCircleLb.attributedText = myMutableString
        switch reliType {
        case .A1, .A2, .A3, .B1, .B2:
            self.interestNameLb.text = "Lãi suất thấp"
        default:
            self.interestNameLb.text = "Lãi suất cao"
        }

        self.interestDes.text = rate.toString() + "/năm, trả góp hàng tháng"
        alreadyAmountCircleProgressView.innerRingColor = reliType.color
        alreadyAmountCircleProgressView.minValue = 0
        alreadyAmountCircleProgressView.maxValue = 100
        //fix to test
        var already : Float = 25
        if let temp = cellData.funded {
            already = temp
        }
        self.alreadyProgress.text = already.toString()
        alreadyAmountCircleProgressView.value = CGFloat(already)
        alreadyAmountCircleProgressView.font = UIFont(name: "SFProDisplay-Semibold", size: 17)!
        alreadyAmountCircleProgressView.shouldShowValueText = false
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        var avaiableAmountStr = ""
        let avaiableAmount = Float(cellData.amount!) - (Float(cellData.amount!) * already / 100)

        if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
            avaiableAmountStr = formattedTipAmount
        } else {
            avaiableAmountStr = "\(avaiableAmount)"
        }
        self.alreadyDesLb.text = "Đã huy động " + "\(already)" + "%, còn lại " +  avaiableAmountStr
        // last block
//        let alreadyStr = cellData.alreadyAmount.toString() + "%"
//        let range2 = NSRange(location: alreadyStr.length() - 1, length: 1)
//        var alreadyMutableStr = NSMutableAttributedString()
//        alreadyMutableStr = NSMutableAttributedString(string: alreadyStr)
//        alreadyMutableStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "SF Pro Display", size: 11)!, range: range2)
//        self.alreadyProgress.attributedText = alreadyMutableStr

        
//        self.alreadyProgress.text = cellData.alreadyAmount.toString()
        /*
        self.alreadyNameLb.text = "Đã huy động"
        var avaiableAmountStr = ""
        let avaiableAmount = cellData.amount - (cellData.alreadyAmount / 100 * cellData.amount)
        alreadyAmountCircleProgressView.innerRingColor =  cellData.reliability.color
        alreadyAmountCircleProgressView.minValue = 0
        alreadyAmountCircleProgressView.maxValue = 100
        alreadyAmountCircleProgressView.value = CGFloat(cellData.alreadyAmount)
        alreadyAmountCircleProgressView.font = UIFont(name: "SFProDisplay-Semibold", size: 17)!
        alreadyAmountCircleProgressView.shouldShowValueText = false
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
            avaiableAmountStr = formattedTipAmount
        } else {
            avaiableAmountStr = avaiableAmount.toString()
        }
        self.alreadyDesLb.text = "Đã huy động " + cellData.alreadyAmount.toString() + "%, còn lại " +  avaiableAmountStr
    */
        // set up cell mode
        self.updateCellMode()
    }
    /// Lấy dữ liệu từ CoreData
    ///
    /// - Parameter completion: <#completion description#>
//    func fetchCoreData(completion: () -> Void) {
//        guard let context = self.managedContext else { return }
//        //Lay list entity
//        let list = FinPlusHelper.fetchRecordsForEntity("LoanCategory", inManagedObjectContext: context)
//        guard list.count > 0 else { return }
//        DataManager.shared.loanCategories.removeAll()
//        for entity in list {
//            var loan = LoanCategories(object: NSObject())
//            if let title = entity.value(forKey: CDLoanCategoryTitle) as? String {
//                loan.title = title
//            }
//            if let desc = entity.value(forKey: CDLoanCategoryDescription) as? String {
//                loan.descriptionValue = desc
//            }
//            if let id = entity.value(forKey: CDLoanCategoryID) as? Int16 {
//                loan.id = id
//            }
//            if let max = entity.value(forKey: CDLoanCategoryMax) as? Int32 {
//                loan.max = max
//            }
//            if let min = entity.value(forKey: CDLoanCategoryMin) as? Int32 {
//                loan.min = min
//            }
//            if let termMax = entity.value(forKey: CDLoanCategoryTermMax) as? Int16 {
//                loan.termMax = termMax
//            }
//            if let termMin = entity.value(forKey: CDLoanCategoryTermMin) as? Int16 {
//                loan.termMin = termMin
//            }
//            if let interestRate = entity.value(forKey: CDLoanCategoryInterestRate) as? Double {
//                loan.interestRate = interestRate
//            }
//            if let url = entity.value(forKey: CDLoanCategoryImageURL) as? String {
//                loan.imageUrl = url
//            }
//            DataManager.shared.loanCategories.append(loan)
//        }
//        completion()
//    }

    func updateCellMode() {
        if UserDefaults.standard.bool(forKey: APP_MODE) == true {
            self.contentView.backgroundColor = DARK_BACKGROUND_COLOR
            // first block
            self.realibilityNameLb.textColor = DARK_BODY_TEXT_COLOR
            self.realibilityDesLb.textColor = DARK_SUBTEXT_COLOR
            // second block
            self.loanTypeNameLb.textColor = DARK_BODY_TEXT_COLOR
            self.loanExpireMonth.textColor = DARK_SUBTEXT_COLOR
            // third block
            self.interestNameLb.textColor = DARK_BODY_TEXT_COLOR
            self.interestDes.textColor = DARK_SUBTEXT_COLOR
            // last block
            self.alreadyNameLb.textColor = DARK_BODY_TEXT_COLOR
            self.alreadyDesLb.textColor = DARK_SUBTEXT_COLOR
            alreadyAmountCircleProgressView.fontColor = DARK_BODY_TEXT_COLOR
        } else {
//            self.contentView.backgroundColor = LIGHT_BACKGROUND_COLOR
            self.contentView.backgroundColor = UIColor.white

            // first block
            self.realibilityNameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.realibilityDesLb.textColor = LIGHT_SUBTEXT_COLOR
            // second block
            self.loanTypeNameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.loanExpireMonth.textColor = LIGHT_SUBTEXT_COLOR
            // third block
            self.interestNameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.interestDes.textColor = LIGHT_SUBTEXT_COLOR
            // last block
            self.alreadyNameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.alreadyDesLb.textColor = LIGHT_SUBTEXT_COLOR
            alreadyAmountCircleProgressView.fontColor = LIGHT_BODY_TEXT_COLOR
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
