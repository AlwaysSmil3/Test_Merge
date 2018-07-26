//
//  InvestListViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import CoreData

public enum LoanReliability : String {
    
    case A1 = "A1"
    case A2 = "A2"
    case A3 = "A3"
    case B1 = "B1"
    case B2 = "B2"
    case B3 = "B3"
    case C1 = "C1"
    case C2 = "C2"
    case C3 = "C3"
    case D = "D"

    var color : UIColor {
        switch self {
        case .A1:
            return POSITIVE1_COLOR
        case .A2:
            return POSITIVE2_COLOR
        case .A3:
            return POSITIVE3_COLOR
        case .B1:
            return POSITIVE4_COLOR
        case .B2:
            return POSITIVE5_COLOR
        case .B3:
            return NAGATIVE1_COLOR
        case .C1:
            return NAGATIVE2_COLOR
        case .C2:
            return NAGATIVE3_COLOR
        case .C3:
            return NAGATIVE4_COLOR
        case .D:
            return NAGATIVE5_COLOR
        }
    }
}

class InvestListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var loanCategories : [LoanCategories] = [LoanCategories]()
    @IBOutlet weak var subTitleLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var allLoansDemoArray : [DemoLoanModel] = [DemoLoanModel]()
    var allLoansArray : [BrowwerActiveLoan] = [BrowwerActiveLoan]()
    var mode = false
    // CoreData
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        return appDelegate.managedObjectContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLoanCategories()
        self.fetchCoreData {
            self.loanCategories = DataManager.shared.loanCategories
//            DataManager.shared.loanCate
//            if loanCategories.count > 0 {
//                for loanCategoryDetail in loanCategories {
//                    if (loanCategoryDetail.id! == cellData.id) {
//                        if let imageUrl = loanCategoryDetail.imageUrl {
//                            let urlString = hostLoan + imageUrl
//                            let url = URL(string: urlString)
//                            self.loanTypeImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic_homeBrower_group1"))
//                        }
//                    }
//                }
//            }
        }
        self.title = "Đầu tư"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.tableView.register(UINib(nibName: "InvestTableViewCell", bundle: nil), forCellReuseIdentifier: "InvestTableViewCell")
        //self.getAllLoans()
        updateData()
        // Do any additional setup after loading the view.
    }

    func fetchCoreData(completion: () -> Void) {
        guard let context = self.managedContext else { return }
        //Lay list entity
        let list = FinPlusHelper.fetchRecordsForEntity("LoanCategory", inManagedObjectContext: context)
        guard list.count > 0 else { return }
        DataManager.shared.loanCategories.removeAll()
        for entity in list {
            var loan = LoanCategories(object: NSObject())
            if let title = entity.value(forKey: CDLoanCategoryTitle) as? String {
                loan.title = title
            }
            if let desc = entity.value(forKey: CDLoanCategoryDescription) as? String {
                loan.descriptionValue = desc
            }
            if let id = entity.value(forKey: CDLoanCategoryID) as? Int16 {
                loan.id = id
            }
            if let max = entity.value(forKey: CDLoanCategoryMax) as? Int32 {
                loan.max = max
            }
            if let min = entity.value(forKey: CDLoanCategoryMin) as? Int32 {
                loan.min = min
            }
            if let termMax = entity.value(forKey: CDLoanCategoryTermMax) as? Int16 {
                loan.termMax = termMax
            }
            if let termMin = entity.value(forKey: CDLoanCategoryTermMin) as? Int16 {
                loan.termMin = termMin
            }
            if let interestRate = entity.value(forKey: CDLoanCategoryInterestRate) as? Double {
                loan.interestRate = interestRate
            }
            if let url = entity.value(forKey: CDLoanCategoryImageURL) as? String {
                loan.imageUrl = url
            }
            DataManager.shared.loanCategories.append(loan)
        }
        completion()
    }


    // Lấy danh sách các loại khoản vay
    func getLoanCategories() {
        guard DataManager.shared.isUpdateFromConfig || DataManager.shared.loanCategories.count == 0 else { return }
        //Có thay đổi cần cập nhật lại dữ liệu
        //self.updateCoreData()
        
//        APIClient.shared.getLoanCategories()
//            .done(on: DispatchQueue.main) { model in
//                print(model)
//                DataManager.shared.loanCategories = model
//                // self.mainCollectionView.reloadData()
//                self.updateCoreData()
//            }
//            .catch { error in }
    }

    func updateCoreData() {
        guard let context = self.managedContext else { return }
        //Lay list entity
        let list = FinPlusHelper.fetchRecordsForEntity("LoanCategory", inManagedObjectContext: context)
        let entity = NSEntityDescription.entity(forEntityName: "LoanCategory", in: context)
        if list.count > 0 {
            //Xoa dữ liệu hiện tại
            for i in list {
                context.delete(i)
            }
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }
        }
        // Cập nhật dữ liệu mới
        for data in DataManager.shared.loanCategories {
            let categoryEntity = NSManagedObject(entity: entity!, insertInto: self.managedContext)
            categoryEntity.setValue(data.id, forKey: CDLoanCategoryID)
            categoryEntity.setValue(data.title, forKey: CDLoanCategoryTitle)
            categoryEntity.setValue(data.descriptionValue, forKey: CDLoanCategoryDescription)
            categoryEntity.setValue(data.min, forKey: CDLoanCategoryMin)
            categoryEntity.setValue(data.max, forKey: CDLoanCategoryMax)
            categoryEntity.setValue(data.termMin, forKey: CDLoanCategoryTermMin)
            categoryEntity.setValue(data.termMax, forKey: CDLoanCategoryTermMax)
            categoryEntity.setValue(data.interestRate, forKey: CDLoanCategoryInterestRate)
            categoryEntity.setValue(data.imageUrl, forKey: CDLoanCategoryImageURL)
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }

        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check mode and change
        if self.navigationController?.isNavigationBarHidden == false {
            self.navigationController?.isNavigationBarHidden = true
        }
        self.getInvesableLoans()
        self.mode = UserDefaults.standard.bool(forKey: APP_MODE)
        setupMode()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func updateData() {
        // fixed data to test UI
        let loan1 = DemoLoanModel(id: 1, reliability: .A1, name: "Vay cho sinh viên", interestRate: 20, amount: 5000000, alreadyAmount: 0, dueMonth: 6)
        let loan2 = DemoLoanModel(id: 2, reliability: .A2, name: "Vay mua điện thoại", interestRate: 22, amount: 12000000, alreadyAmount: 75, dueMonth: 12)
        let loan3 = DemoLoanModel(id: 3, reliability: .A3, name: "Vay mua xe máy", interestRate: 22, amount: 12000000, alreadyAmount: 50, dueMonth: 12)
        let loan4 = DemoLoanModel(id: 4, reliability: .B1, name: "Vay mua điện thoại", interestRate: 25, amount: 12000000, alreadyAmount: 45, dueMonth: 6)
        let loan5 = DemoLoanModel(id: 5, reliability: .B2, name: "Vay mua điện thoại", interestRate: 28, amount: 12000000, alreadyAmount: 30, dueMonth: 12)
        let loan6 = DemoLoanModel(id: 6, reliability: .B3, name: "Vay mua điện thoại", interestRate: 30, amount: 12000000, alreadyAmount: 15, dueMonth: 6)
        let loan7 = DemoLoanModel(id: 7, reliability: .C1, name: "Vay mua điện thoại", interestRate: 35, amount: 12000000, alreadyAmount: 90, dueMonth: 6)
        let loan8 = DemoLoanModel(id: 8, reliability: .C2, name: "Vay mua điện thoại", interestRate: 40, amount: 12000000, alreadyAmount: 80, dueMonth: 12)
        let loan9 = DemoLoanModel(id: 8, reliability: .C3, name: "Vay mua điện thoại", interestRate: 40, amount: 12000000, alreadyAmount: 80, dueMonth: 12)
        let loan10 = DemoLoanModel(id: 8, reliability: .D, name: "Vay mua điện thoại", interestRate: 40, amount: 12000000, alreadyAmount: 80, dueMonth: 12)
        self.allLoansDemoArray.append(loan1)
        self.allLoansDemoArray.append(loan2)
        self.allLoansDemoArray.append(loan3)
        self.allLoansDemoArray.append(loan4)
        self.allLoansDemoArray.append(loan5)
        self.allLoansDemoArray.append(loan6)
        self.allLoansDemoArray.append(loan7)
        self.allLoansDemoArray.append(loan8)
        self.allLoansDemoArray.append(loan9)
        self.allLoansDemoArray.append(loan10)
    }

    // Lấy danh sách tất cả các khoản vay
    private func getInvesableLoans() {
        APIClient.shared.getInvesableLoans()
            .done(on: DispatchQueue.main) { model in
                 print(model)
                self.allLoansArray = model
//                self.allLoansArray = model
                self.tableView.reloadData()
                // let _ : BrowwerActiveLoan = model
            }
            .catch { error in }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLoansArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = allLoansArray[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "InvestTableViewCell", for: indexPath) as? InvestTableViewCell {
            cell.cellData = cellData
            cell.loanCategories = self.loanCategories
            cell.updateCellView()
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellData = allLoansArray[indexPath.row]
        let investStoryBoard = UIStoryboard(name: "Invest", bundle: nil)
        let investDetailVC = investStoryBoard.instantiateViewController(withIdentifier: "InvestDetailViewController") as! InvestDetailViewController
        investDetailVC.investData = cellData
        if self.loanCategories.count == 0 {
            self.fetchCoreData {
                investDetailVC.loanCategories = self.loanCategories
                self.navigationController?.pushViewController(investDetailVC, animated: true)

            }
        } else {
            investDetailVC.loanCategories = self.loanCategories
            self.navigationController?.pushViewController(investDetailVC, animated: true)
        }
//        print(self.loanCategories.count)
//        investDetailVC.loanCategories = self.loanCategories
//        self.navigationController?.pushViewController(investDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func setupMode() {
        if (self.mode)
        {
            self.tableView.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            self.view.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            self.titleLb.textColor = DARK_BODY_TEXT_COLOR
            self.subTitleLb.textColor = DARK_SUBTEXT_COLOR

            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = DARK_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = DARK_BODY_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: DARK_BODY_TEXT_COLOR]
        }
        else
        {
            self.tableView.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            self.view.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            self.titleLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.subTitleLb.textColor = LIGHT_SUBTEXT_COLOR

            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = LIGHT_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = LIGHT_BODY_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: LIGHT_BODY_TEXT_COLOR]
        }

        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
