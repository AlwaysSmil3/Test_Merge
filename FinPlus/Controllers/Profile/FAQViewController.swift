//
//  FAQViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var faqViewContainer: UIView!
    
    var faqView: FAQView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("FAQ", comment: "")
        
        var items = [FAQItem]()
        if let config = DataManager.shared.config {
            if let faq = config.faq {
                for item in faq {
                    items.append(FAQItem(question: item.title!, answer: item.descriptionValue!))
                }
            }
        }
        
//        let items = [FAQItem(question: "What is reddit?", answer: "reddit is a source for what's new and popular on the web. Users like you provide all of the content and decide, through voting, what's good and what's junk. Links that receive community approval bubble up towards #1, so the front page is constantly in motion and (hopefully) filled with fresh, interesting links."), FAQItem(question: "What does the name \"reddit\" mean?", answer: "It's (sort of) a play on words -- i.e., \"I read it on reddit.\" Also, there are some unintentional but interesting Latin meanings to the word \"reddit\"."), FAQItem(question: "How is a submission's score determined?", answer: "A submission's score is simply the number of upvotes minus the number of downvotes. If five users like the submission and three users don't it will have a score of 2. Please note that the vote numbers are not \"real\" numbers, they have been \"fuzzed\" to prevent spam bots etc. So taking the above example, if five users upvoted the submission, and three users downvote it, the upvote/downvote numbers may say 23 upvotes and 21 downvotes, or 12 upvotes, and 10 downvotes. The points score is correct, but the vote totals are \"fuzzed\".")]
        
        let mode = UserDefaults.standard.bool(forKey: APP_MODE)
        let isInvestor = false
        
        faqView = FAQView(frame: faqViewContainer.frame, items: items)
        faqView.layer.borderWidth = 1
        faqView.layer.cornerRadius = 8
        faqView.questionTextFont = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        faqView.answerTextFont = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SEMIMALL)
        
        if mode && isInvestor {
            self.view.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            faqView.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            faqView.layer.borderColor = DARK_MODE_BORDER_COLOR.cgColor
            faqView.questionTextColor = DARK_MODE_MAIN_TEXT_COLOR
            faqView.answerTextColor = DARK_MODE_SUB_TEXT_COLOR
            faqView.separatorColor = DARK_MODE_BORDER_COLOR
            faqView.viewBackgroundColor = DARK_MODE_BACKGROUND_COLOR
            faqView.cellBackgroundColor = DARK_MODE_BACKGROUND_COLOR
            faqView.tableView.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            faqViewContainer.backgroundColor = DARK_MODE_BACKGROUND_COLOR
        } else {
            self.view.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            faqView.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            faqView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
            faqView.questionTextColor = LIGHT_MODE_MAIN_TEXT_COLOR
            faqView.answerTextColor = LIGHT_MODE_SUB_TEXT_COLOR
            faqView.separatorColor = LIGHT_MODE_BORDER_COLOR
            faqView.viewBackgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            faqView.cellBackgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            faqView.tableView.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            faqViewContainer.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
        }
        
        faqView.translatesAutoresizingMaskIntoConstraints = false
        faqViewContainer.addSubview(faqView)
        addFaqViewConstraints()
    }
    
    func addFaqViewConstraints() {
        let faqViewTrailing = NSLayoutConstraint(item: faqView, attribute: .trailing, relatedBy: .equal, toItem: self.faqViewContainer, attribute: .trailingMargin, multiplier: 1, constant: 0)
        let faqViewLeading = NSLayoutConstraint(item: faqView, attribute: .leading, relatedBy: .equal, toItem: self.faqViewContainer, attribute: .leadingMargin, multiplier: 1, constant: 0)
        let faqViewTop = NSLayoutConstraint(item: faqView, attribute: .top, relatedBy: .equal, toItem: self.faqViewContainer, attribute: .top, multiplier: 1, constant: 0)
        let faqViewBottom = NSLayoutConstraint(item: faqView, attribute: .bottom, relatedBy: .equal, toItem: self.faqViewContainer, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([faqViewTop, faqViewBottom, faqViewLeading, faqViewTrailing])
    }
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
}
