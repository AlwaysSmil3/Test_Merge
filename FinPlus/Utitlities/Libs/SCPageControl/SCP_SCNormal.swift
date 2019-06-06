//
//  SCPageControl_normal.swift
//  Pods
//
//  Created by Myoung on 2017. 4. 27..
//
//

import UIKit

class SCP_SCNormal: UIView {

    var numberOfPage: Int = 0, currentOfPage: Int = 0
    var f_start_point: CGFloat = 0.0, f_start: CGFloat = 0.0
    
    let long_width: CGFloat = 11
    let short_width: CGFloat = 4
    let all_height: CGFloat = 4
    let merge: CGFloat = 4
    
    var tin_color: UIColor = .red
    var invisible_color: UIColor = .gray
    var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // ## view init method ##
    func set_view(_ page: Int, current: Int, tint_color: UIColor, invisiblet_color: UIColor) {
        
        tin_color = tint_color
        invisible_color = invisiblet_color
        numberOfPage = page
        currentOfPage = current
        
        let f_all_width: CGFloat = CGFloat(numberOfPage-1)*(merge + short_width) + long_width
        
        guard f_all_width < self.frame.size.width else {
            print("frame.Width over Number Of Page")
            return
        }
        
        var f_width: CGFloat = short_width, f_height: CGFloat = all_height
        var f_x: CGFloat = (self.frame.size.width-f_all_width)/2.0, f_y: CGFloat = (self.frame.size.height-f_height)/2.0
        
        f_start_point = f_x
        
        for i in 0 ..< numberOfPage {
            let img_page = UIImageView()
            
            if i == currentOfPage {
                f_width = long_width
                img_page.backgroundColor = tin_color
            } else {
                f_width = short_width
                img_page.backgroundColor = invisible_color
            }
            
            img_page.frame = CGRect(x: f_x, y: f_y, width: f_width, height: f_height)
            img_page.layer.cornerRadius = img_page.frame.size.height/2.0
            img_page.tag = i+Int(merge)
            self.addSubview(img_page)
            
            f_x += f_width + merge
        }        
    }
    
    // ## Call the move page in scrollView ##
    func scroll_did(_ scrollView: UIScrollView) {
        
        let f_page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        let tag_value = get_imgView_tag(f_page)+Int(merge)
        let f_next_start: CGFloat = (CGFloat(tag_value-Int(merge)) * scrollView.frame.size.width)
        
        let f_move: CGFloat = ((long_width-merge)*(f_start-scrollView.contentOffset.x)/scrollView.frame.size.width)
        let f_alpha: CGFloat = (0.6*(scrollView.contentOffset.x-f_next_start)/scrollView.frame.size.width)
        
        if let iv_page: UIImageView = self.viewWithTag(tag_value) as? UIImageView,
            tag_value >= Int(merge) && tag_value+1 < Int(merge)+numberOfPage {
            
            iv_page.frame = CGRect(x: f_start_point+((CGFloat(tag_value)-merge)*(short_width+merge)),
                                   y: iv_page.frame.origin.y,
                                   width: long_width+(f_move+((CGFloat(tag_value)-merge)*(long_width-merge))),
                                   height: iv_page.frame.size.height)
            if (1-f_alpha >= 0.6)
            {
                iv_page.backgroundColor = tin_color
            }
            else
            {
                iv_page.backgroundColor = invisible_color
            }
            
            if let iv_page_next: UIImageView = self.viewWithTag(tag_value+1) as? UIImageView {
                let f_page_next_x: CGFloat = ((f_start_point+long_width+merge)+((CGFloat(tag_value)-merge)*(short_width+merge)))
                iv_page_next.frame = CGRect(x: f_page_next_x+(f_move+((CGFloat(tag_value)-merge)*(long_width-merge))),
                                            y: iv_page_next.frame.origin.y,
                                            width: short_width-(f_move+((CGFloat(tag_value)-merge)*(long_width-merge))),
                                            height: iv_page_next.frame.size.height)
                if (0.4+f_alpha >= 0.6)
                {
                    iv_page_next.backgroundColor = tin_color
                }
                else
                {
                    iv_page_next.backgroundColor = invisible_color
                }
                
            }
        }
    }
    
    // ## return ImageView tag number ##
    func get_imgView_tag(_ f_page: CGFloat) -> Int {
        let f_temp = f_page - 0.02
        return Int(f_temp)
    }
    
    // ## Call the moment in rotate Device ##
    func set_rotateDevice(_ frame: CGRect) {
        self.frame = frame
        let f_all_width: CGFloat = CGFloat(numberOfPage-1)*(merge + short_width) + long_width
        var f_x: CGFloat = (self.frame.size.width-f_all_width)/2.0
        
        f_start_point = f_x
        
        for subview in self.subviews {
            if subview.isKind(of: UIImageView.classForCoder()) {
                subview.frame.origin.x = f_x
                f_x += subview.frame.size.width + merge
            }
        }
    }
}
