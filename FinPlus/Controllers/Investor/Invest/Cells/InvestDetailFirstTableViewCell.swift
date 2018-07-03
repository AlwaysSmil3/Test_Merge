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
    }

    func updateCellView() {
        // first block
        self.realibilityCircleLb.layer.cornerRadius = 22
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
//        let interestCircleStr = rate.toString() + "\n%/năm"
//        let myRange = NSRange(location: interestCircleStr.length() - 5, length: 5)
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: interestCircleStr)
//        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "SF Pro Display", size: 8)!, range: myRange)
//        self.interestCircleLb.attributedText = myMutableString
        self.interestCircleLb.text = rate.toString()
        self.interestCircleLb.adjustsFontSizeToFitWidth = true
        self.interestCircleLb.minimumScaleFactor = 0.5
        
        // change font self.interestCircleLb suitable with contect
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
        var amount : Float = 0
        var funded : Float = 0
        if let temp = cellData.amount {
            amount = Float(temp)
        }
        if let temp = cellData.funded {
            funded = temp
        }
        
        let fundedPercent : Float = funded / amount * 100
        
        
        self.alreadyProgress.text = fundedPercent.toString()
        // set font size suitable with text
        self.alreadyProgress.numberOfLines = 1
        self.alreadyProgress.adjustsFontSizeToFitWidth = true;
        self.alreadyProgress.minimumScaleFactor = 0.5

        alreadyAmountCircleProgressView.value = CGFloat(fundedPercent)
        alreadyAmountCircleProgressView.font = UIFont(name: "SFProDisplay-Semibold", size: 17)!
        alreadyAmountCircleProgressView.shouldShowValueText = false
        
        self.alreadyDesLb.text = "Đã huy động " + fundedPercent.toString() + "%, còn lại " +  (amount - funded).toLocalCurrencyFormat()

        // set up cell mode
        self.updateCellMode()
    }

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
