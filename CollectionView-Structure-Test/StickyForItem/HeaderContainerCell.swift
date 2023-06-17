//
//  HeaderContainerCell.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

class HeaderContainerCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
