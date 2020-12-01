//
//  CategoryDrinks.swift
//  BOMarket
//
//  Created by Nguyen Phong on 29/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import Foundation

enum DrinksType : Int{
    case Alcohol
    case International
    case FreshWater
    case Beverage
    case JuiceFruit
}

struct CategoryDrinks {
    let Title:String
    let ImageName:String
    let DrinkType:DrinksType
    /*
    init(Title title:String, ImageName image:String, DrinkType drk:DrinksType) {
        Title = title
        ImageName = image
        DrinkType = drk
    }
 */
}
