//
//  ViewController.swift
//  BOMarket
//
//  Created by imac 2015 4k on 9/16/20.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let SearchBarHeight = CGFloat(40)
    let HeaderMaxHeight = CGFloat(95)
    let Duration = TimeInterval(0.2)
    let SearchBarMinTrailingConst = CGFloat(18)
    
    var startScrollY:CGFloat = 0
    var alredyTop:Bool = false
    var alredyBottom:Bool = false
    var dragging:Bool = false
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTraling: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        self.InitCollectionView(collectionView: collectionView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let offset = currentOffset - startScrollY;
        startScrollY = currentOffset
        applyChange(byOffset: offset)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //sometime start scroll when
        dragging = true
        startScrollY = scrollView.contentOffset.y
        //print("scroll Begin: \(startScrollY)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
        if !decelerate{
            fitSearchBar(scrollView, willDecelerate: decelerate)
        }
        //print("End draging")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fitSearchBar(scrollView, willDecelerate: false)
        //print("done...")
    }
    
    func applyChange(byOffset offset:CGFloat){
        
        //print("offset: \(offset) dragging: \(dragging) startScrollY: \(startScrollY)")
        
        if offset > 0 && startScrollY < 0{
            return
        }
        if offset < 0 && startScrollY > SearchBarHeight{
            return
        }
        let currentValue = headerHeight.constant
        let expectValue = currentValue - offset
        if expectValue <= HeaderMaxHeight - SearchBarHeight{
            if alredyTop{
                return
            }
            headerHeight.constant = HeaderMaxHeight - SearchBarHeight
            self.trailPaddingAndAlpha()
            alredyTop = true
            alredyBottom = false
        }else if expectValue >= HeaderMaxHeight{
            if alredyBottom{
                return
            }
            headerHeight.constant = HeaderMaxHeight
            self.trailPaddingAndAlpha()
            alredyBottom = true
            alredyTop = false
        }else{
            if !dragging && alredyBottom{
                return
            }
            
            alredyBottom = false
            alredyTop = false
            headerHeight.constant = expectValue
            self.trailPaddingAndAlpha()
        }
    }
    
    func trailPaddingAndAlpha(){
        searchTraling.constant = SearchBarMinTrailingConst + (HeaderMaxHeight - headerHeight.constant)
        iconImg.alpha = (headerHeight.constant - SearchBarHeight)/(HeaderMaxHeight-SearchBarHeight)
    }
    
    func fitSearchBar(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        let currentOffset = scrollView.contentOffset.y
        let currentHeight = headerHeight.constant
        //print("currentHeight: \(currentHeight) currentOffset:\(currentOffset)")
        if !decelerate && currentOffset < 0.8*SearchBarHeight && !alredyBottom{
            //print("Go top")
            alredyBottom = true
            alredyTop = false
            //scrollView.setContentOffset(CGPoint.zero, animated: false)
            self.headerHeight.constant = self.HeaderMaxHeight
            self.trailPaddingAndAlpha()
            self.view.layoutIfNeeded()
        }else{
            if currentHeight < 0.8*HeaderMaxHeight {
                if !alredyTop{
                    //print("Animation to top")
                    UIView.animate(withDuration: Duration, animations: {
                        self.headerHeight.constant = self.HeaderMaxHeight - self.SearchBarHeight
                        self.trailPaddingAndAlpha()
                        self.view.layoutIfNeeded()
                    }, completion: {result in
                        
                    })
                }
            }else if !alredyBottom{
                //print("Animation to bottom")
                UIView.animate(withDuration: Duration, animations: {
                    self.headerHeight.constant = self.HeaderMaxHeight
                    self.trailPaddingAndAlpha()
                    self.view.layoutIfNeeded()
                }, completion: {result in
                    
                })
            }
        }
    }
}
