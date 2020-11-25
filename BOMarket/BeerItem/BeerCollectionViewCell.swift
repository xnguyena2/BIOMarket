//
//  BeerCollectionViewCell.swift
//  BOMarket
//
//  Created by Nguyen Phong on 17/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
    
    static let Identify = "BeerCollectionViewCell"
    
    @IBOutlet weak var beerDetail: UILabel!
    
    @IBOutlet weak var price: UILabel!
        
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var currency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupLayout()
    }
    
    func setupLayout(){
        //beerDetail.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        let attributedCurrency = NSMutableAttributedString.init(string: "đ")
        attributedCurrency.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: 1))
        currency.attributedText = attributedCurrency
    }

}
