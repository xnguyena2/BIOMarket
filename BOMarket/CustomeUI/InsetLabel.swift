//
//  InsetLabel.swift
//  BOMarket
//
//  Created by Nguyen Phong on 23/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var topInset: CGFloat  = 0.5
    @IBInspectable var bottomInset: CGFloat  = 0.5
    @IBInspectable var leftInset: CGFloat  = 0.5
    @IBInspectable var rightInset: CGFloat  = 0.5
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize{
        return addInsets(to: super.intrinsicContentSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }
    
    private func addInsets(to size: CGSize) -> CGSize{
        let width = size.width+leftInset+rightInset
        let height = size.height+topInset+bottomInset
        return CGSize(width: width, height: height)
    }

}
