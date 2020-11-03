//
//  Carousel.swift
//  BOMarket
//
//  Created by imac 2015 4k on 10/22/20.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

final class MyRecognizer: UIGestureRecognizer {
    var startTouch: CGPoint!
    var mainView: Carousel!
    
    public func setMainView(mainView: Carousel){
        self.mainView = mainView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            startTouch = touch.location(in: nil)
            mainView?.touchesBegan()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            if startTouch == nil {
                return
            }
            let position = touch.location(in: nil)
            mainView?.touchesMoved(translation: position.x - startTouch.x)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        mainView.touchesEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        print("cancel touch")
        startTouch = nil
        mainView.touchesEnded()
    }
}

final class CarouselItem {
    
    lazy var contentView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "app_beer_logo")
        contentView.backgroundColor = .gray
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private var headAnchor: NSLayoutConstraint!
    private var trailAnchor: NSLayoutConstraint!
    
    var startPoint: CGFloat!
    var startPointt: CGFloat!
    
    public func GetUIImage() -> UIImageView {
        return contentView
    }
    
    public func AlinImage(container: UIView){
        headAnchor = contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30)
        trailAnchor = contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            headAnchor,
            trailAnchor
        ])
    }
    
    public func TouchesBegan(){
        startPoint = headAnchor.constant
        startPointt = trailAnchor.constant
    }
    
    public func TouchesMoved(translation: CGFloat){
        headAnchor.constant = startPoint+translation
        trailAnchor.constant = startPointt+translation
    }
    
}

final class Carousel: UIView {
    
    var currentIndex = 0
    
    let listCrs = [CarouselItem()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        backgroundColor = .red
        
        addSubview(listCrs[currentIndex].GetUIImage())
        
        setupLayout()
        
        let gesture = MyRecognizer(target: self, action:  #selector(self.checkAction))
        gesture.setMainView(mainView: self)
        self.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("touch")
    }
    
    private func setupLayout(){
        listCrs[currentIndex].AlinImage(container: self)
    }
    
    private func configView(){
        guard let view  = self.LoadFileFromNib(nibName: "Carousel")
        else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    public func touchesBegan(){
        listCrs[currentIndex].TouchesBegan()
    }
    
    public func touchesMoved(translation: CGFloat){
        listCrs[currentIndex].TouchesMoved(translation: translation)
        setNeedsLayout()
    }
    
    public func touchesEnded(){
        
    }
}
