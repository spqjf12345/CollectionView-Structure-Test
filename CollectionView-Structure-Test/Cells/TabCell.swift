//
//  TabCell.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/13.
//

import UIKit

final class TabCell: UICollectionViewCell {
    
    @IBOutlet weak var tabLabel: UILabel!
    @IBOutlet weak var divider: UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(with tab: Tab) {
        tabLabel.text = tab.name
        tabLabel.textColor = .gray
        divider.backgroundColor = .systemGray6
        
        updateSelectedColor(isSelected: tab.isSelected)
    }
    
    func updateSelectedColor(isSelected: Bool) {
        tabLabel.textColor = isSelected ? .black : .gray
        divider.backgroundColor = isSelected ? .black : .systemGray6
    }
    
}
