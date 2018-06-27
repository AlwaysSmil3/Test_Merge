//
//  FAQViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    var faqView: FAQView!
    @IBOutlet weak var faqViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("FAQ", comment: "")
        
        let items = [FAQItem(question: "What is reddit?", answer: "reddit is a source for what's new and popular on the web. Users like you provide all of the content and decide, through voting, what's good and what's junk. Links that receive community approval bubble up towards #1, so the front page is constantly in motion and (hopefully) filled with fresh, interesting links."), FAQItem(question: "What does the name \"reddit\" mean?", answer: "It's (sort of) a play on words -- i.e., \"I read it on reddit.\" Also, there are some unintentional but interesting Latin meanings to the word \"reddit\"."), FAQItem(question: "How is a submission's score determined?", answer: "A submission's score is simply the number of upvotes minus the number of downvotes. If five users like the submission and three users don't it will have a score of 2. Please note that the vote numbers are not \"real\" numbers, they have been \"fuzzed\" to prevent spam bots etc. So taking the above example, if five users upvoted the submission, and three users downvote it, the upvote/downvote numbers may say 23 upvotes and 21 downvotes, or 12 upvotes, and 10 downvotes. The points score is correct, but the vote totals are \"fuzzed\".")]
        
        faqView = FAQView(frame: faqViewContainer.frame, items: items)
        faqView.backgroundColor = .white
        faqView.layer.borderColor = UIColor.gray.cgColor
        faqView.layer.borderWidth = 1
        faqView.layer.cornerRadius = 8
        faqView.questionTextFont = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        faqView.answerTextFont = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SEMIMALL)
        faqView.questionTextColor = UIColor(hexString: "#08121E")
        faqView.answerTextColor = UIColor(hexString: "#4D6678")
        faqView.separatorColor = UIColor(hexString: "#DFE3ED")
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
        self.navigationController?.popViewController(animated: true)
    }
    
}
