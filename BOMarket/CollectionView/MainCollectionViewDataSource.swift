//
//  CollectionViewDataSource.swift
//  BOMarket
//
//  Created by Nguyen Phong on 16/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum section:Int{
        case Carousel = 0
        case Beer = 1
    }
    
    func carouselSection() ->NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 48, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        return NSCollectionLayoutSection(group: group)
    }
    
    func beerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                     heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            switch section(rawValue: sectionNumber) {
            case .Carousel:
                return self.carouselSection()
            case .Beer:
                return self.beerSection()
            default:
                return nil
            }
        }
    }
    
    
    public func InitCollectionView(collectionView: UICollectionView){
        registerMyView(collectionView: collectionView)
        collectionView.collectionViewLayout = createLayout()
    }
    
    func registerMyView(collectionView: UICollectionView){
        collectionView.register(UIView().LoadNibWithName(nibName: CarouselCollectionViewCell.Identify), forCellWithReuseIdentifier: CarouselCollectionViewCell.Identify)
        collectionView.register(UIView().LoadNibWithName(nibName: BeerCollectionViewCell.Identify), forCellWithReuseIdentifier: BeerCollectionViewCell.Identify)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch section(rawValue: indexPath.section) {
        case .Carousel:
            let carousel  = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.Identify, for: indexPath) as! CarouselCollectionViewCell
            carousel.LoadSampleImage()
            carousel.SetDelegate(delegate: self)
            return carousel
        case .Beer:
            let beer  = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.Identify, for: indexPath) as! BeerCollectionViewCell
            return beer
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return 20
    }
}

extension ViewController: ScrollStateDelegate{
    func ChangeScrollState(enable: Bool) {
        collectionView?.isScrollEnabled = enable
    }
}
