//
//  StickFlowLayout.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

final class StickyFlowLayout: UICollectionViewFlowLayout {
    
    var stickyIndexPaths: [IndexPath] {
        didSet {
            invalidateLayout()
        }
    }
    
    init(stickyIndexPaths: [IndexPath]) {
        self.stickyIndexPaths = stickyIndexPaths
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        for indexPath in stickyIndexPaths {
            if let stickyAttributes = getStickyAttributes(at: indexPath) {
                layoutAttributes?.append(stickyAttributes)
            }
        }
        
        return layoutAttributes
    }
    
    private func getStickyAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView,
              let stickyAttributes = layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        else {
            return nil
        }
        
        if collectionView.contentOffset.y > stickyAttributes.frame.minY {
            var frame = stickyAttributes.frame
            frame.origin.y = collectionView.contentOffset.y
            stickyAttributes.frame = frame
            stickyAttributes.zIndex = 1
            return stickyAttributes
        }
        return nil
    }
    
}
