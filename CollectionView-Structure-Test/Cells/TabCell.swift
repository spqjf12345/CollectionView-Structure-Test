//
//  TabCell.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/13.
//

import UIKit

protocol TabCellDelegate: AnyObject {
    func didUpdatePage()
}

final class TabCell: UICollectionViewCell {
    
    @IBOutlet weak var tabLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    
    override var isSelected: Bool {
        didSet {
            self.updateSelectedColor(isSelected: isSelected)
        }
    }
    
    weak var delegate: TabCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(with text: String) {
        tabLabel.text = text
        tabLabel.textColor = .gray
        divider.backgroundColor = .systemGray6
    }
    
    func updateSelectedColor(isSelected: Bool) {
        tabLabel.textColor = isSelected ? .black : .gray
        divider.backgroundColor = isSelected ? .black : .systemGray6
    }
    
}
