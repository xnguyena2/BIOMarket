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
    func LoadNibWithName(nibName: String) -> UINib{
        //let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib
    }
    func LoadFileFromNib(nibName: String) -> UIView!{
        return LoadNibWithName(nibName: nibName).instantiate(withOwner: self, options: nil).first as? UIView
    }
}
