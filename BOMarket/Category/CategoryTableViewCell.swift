//
//  CategoryTableViewCell.swift
//  BOMarket
//
//  Created by Nguyen Phong on 29/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    var category:CategoryDrinks!
    
    public static let Identity:String = "CategoryTableViewCell"
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    @IBOutlet weak var bcgView: SelectedCategoryBackground!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        bcgView.Selected(selected)
        // Configure the view for the selected state
    }
    
    public func Config(config cfg:CategoryDrinks){
        if category == nil{
            category = cfg
            categoryTitle.text = cfg.Title
            categoryIcon.image = UIImage(named: cfg.ImageName)
        }
    }
    
}
