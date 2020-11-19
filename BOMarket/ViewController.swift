//
//  ViewController.swift
//  BOMarket
//
//  Created by imac 2015 4k on 9/16/20.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        self.InitCollectionView(collectionView: collectionView)
    }
}

