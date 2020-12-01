//
//  SelectedCategory.swift
//  BOMarket
//
//  Created by Nguyen Phong on 28/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class SelectedCategoryBackground: UIView {
    
    let lineWidth = CGFloat(1)
    let rectangleWidth = CGFloat(15)
    let rectangleHeight = CGFloat(25)
    let leftShipOffset = CGFloat(6)
    let rightShipOffset = CGFloat(1)
    
    var IsSelected:Bool = false
        
    override var bounds: CGRect{
        didSet{
            Selected(IsSelected)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    func setupLayout(){
        //backgroundColor = .clear
    }
    
    public func Selected(_ isSelected:Bool){
        IsSelected = isSelected
        if isSelected{
            addLayer()
        }else{
            backgroundColor = .systemGray4
            cleanALlLayer()
        }
    }
    
    func cleanALlLayer(){
        if let allSubLayer = layer.sublayers{
            for subLayer in allSubLayer where subLayer is CAShapeLayer{
                subLayer.removeFromSuperlayer()
            }
        }
    }
    
    func addLayer(){
        backgroundColor = .clear
        cleanALlLayer()
        let newWidth = bounds.size.width+rightShipOffset
        let path = UIBezierPath()
        path.move(to:CGPoint(x: leftShipOffset, y: 0))
        path.addLine(to:CGPoint(x: newWidth, y: 0))
        path.addLine(to: CGPoint(x: newWidth, y: (bounds.size.height-rectangleHeight)/2))
        path.addLine(to: CGPoint(x: newWidth - rectangleWidth, y: bounds.size.height/2))
        path.addLine(to: CGPoint(x: newWidth, y: (bounds.size.height+rectangleHeight)/2))
        path.addLine(to: CGPoint(x: newWidth, y: bounds.size.height))
        path.addLine(to: CGPoint(x: leftShipOffset, y: bounds.size.height))
        
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        shapeLayer.fillColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        shapeLayer.lineWidth = lineWidth
        
        
        let traiangle = UIBezierPath()
        traiangle.move(to: CGPoint(x: 0, y: 0))
        traiangle.addLine(to: CGPoint(x: leftShipOffset, y: 0))
        traiangle.addLine(to: CGPoint(x: leftShipOffset, y: bounds.size.height))
        traiangle.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        let traiangleLayer = CAShapeLayer()
        traiangleLayer.path = traiangle.cgPath
        traiangleLayer.strokeColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
        traiangleLayer.fillColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
        traiangleLayer.lineWidth = lineWidth
        
        self.layer.addSublayer(shapeLayer)
        self.layer.insertSublayer(traiangleLayer, below: shapeLayer)
    }
}
