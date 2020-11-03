//
//  Extention.swift
//  BOMarket
//
//  Created by imac 2015 4k on 10/23/20.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    func LoadFileFromNib(nibName: String) -> UIView!{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
