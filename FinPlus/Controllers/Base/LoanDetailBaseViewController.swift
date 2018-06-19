//
//  LoanDetailBaseViewController.swift
//  FinPlus
//
//  Created by nghiendv on 15/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class LoanDetailBaseViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var desLabel: UILabel?
    @IBOutlet weak var topButton: UIButton?
    @IBOutlet weak var bottomButton: UIButton?
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var ButtonToTitleConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableToButtonConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableToBottomButtonConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableToDesConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableToTitleConstraint: NSLayoutConstraint?
    @IBOutlet weak var containerView: UIView?
    
    let cellIdentifier = "cell"
    var activeLoan: BrowwerActiveLoan?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let cellNib = UINib(nibName: "DoubleTextTableViewCell", bundle: nil)
        self.tableView?.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.tableView?.tableFooterView = UIView()
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.alwaysBounceVertical = false;
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.cornerRadius = 8
        self.borderView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        
        self.tableToDesConstraint?.isActive = false
//        self.tableToTitleConstraint?.isActive = false
        self.ButtonToTitleConstraint?.isActive = false
        self.tableToButtonConstraint?.isActive = false
        self.tableToBottomButtonConstraint?.isActive = false
        
        if ((self.bottomButton?.isHidden)! == false || (self.topButton?.isHidden)! == false || (self.desLabel?.isHidden)! == false)
        {
            self.tableToTitleConstraint?.isActive = false
        }
        
        if (self.bottomButton?.isHidden)!
        {
            if (self.topButton?.isHidden)!
            {
                if (self.desLabel?.isHidden)!
                {
                    self.tableToTitleConstraint?.isActive = true
                }
                else
                {
                    self.tableToDesConstraint?.isActive = true
                }
            }
            else
            {
                self.tableToButtonConstraint?.isActive = true
                
                if (self.desLabel?.isHidden)!
                {
                    self.ButtonToTitleConstraint?.isActive = true
                }
            }
        }
        else
        {
            self.topButton?.isHidden = false
            self.desLabel?.isHidden = false
            self.tableToBottomButtonConstraint?.isActive = true
        }
        
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableConstraint() {
        
        UIView.animate(withDuration: 0, animations: {
            self.tableView?.layoutIfNeeded()
        }) { (complete) in
            var heightOfTableView: CGFloat = 0.0
            // Get visible cells and sum up their heights
            let cells = self.tableView?.visibleCells
            for cell in cells! {
                heightOfTableView += cell.frame.height
            }
            // Edit heightOfTableViewConstraint's constant to update height of table view
            self.tableViewHeightConstraint?.constant = heightOfTableView
        }
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
