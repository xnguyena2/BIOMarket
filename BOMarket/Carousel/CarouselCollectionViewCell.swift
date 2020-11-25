//
//  CarouselCollectionViewCell.swift
//  BOMarket
//
//  Created by Nguyen Phong on 16/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    
    static let Identify = "CarouselCollectionViewCell"

    @IBOutlet weak var carousel: Carousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func SetDelegate(delegate:ScrollStateDelegate){
        carousel?.delegate = delegate
    }
    
    var doneLoad = false
    
    public func LoadSampleImage(){
        if !doneLoad{
            LoadImage(img: "1")
            LoadImage(img: "2")
            //LoadImage(img: "3")
            doneLoad = true
        }
    }
    
    public func LoadImage(img: String){
        carousel?.LoadItem(img: img)
    }

}
