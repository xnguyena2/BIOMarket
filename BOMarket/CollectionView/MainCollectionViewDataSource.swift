//
//  CollectionViewDataSource.swift
//  BOMarket
//
//  Created by Nguyen Phong on 16/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    // 1
    weak var delegate: CustomCollectionViewLayoutDelegate?
    
    // 2
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private let firstItemRatioSize:CGFloat = 0.4
    
    // 3
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // 4
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // 1
        guard
            //        cache.isEmpty,
            let collectionView = collectionView
        else {
            return
        }
        
        print("Collection contentWidth: \(contentWidth)")
        // 2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        //for carousel
        let carouselHeight = firstItemRatioSize*contentWidth+cellPadding * 2
        let carouseFrame = CGRect(x: 0,
                           y: 0,
                           width: contentWidth,
                           height: carouselHeight)
        let carouselInsetFrame = carouseFrame.insetBy(dx: 0, dy: cellPadding)
        let carouselAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        carouselAttributes.frame = carouselInsetFrame
        cache.append(carouselAttributes)
        //
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: carouselHeight, count: numberOfColumns)
        
        // 3
        for item in 1..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 100
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}


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
                                              heightDimension: .absolute(300))
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
        /*
        collectionView.collectionViewLayout = CustomCollectionViewLayout()
        if let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout {
            layout.delegate = self
        }
        */
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
extension ViewController: CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension ViewController: ScrollStateDelegate{
    func ChangeScrollState(enable: Bool) {
        collectionView?.isScrollEnabled = enable
    }
}
