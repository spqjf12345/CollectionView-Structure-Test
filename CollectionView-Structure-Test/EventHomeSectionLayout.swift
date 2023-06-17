//
//  EventHomeSectionLayout.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

final class EventHomeSectionLayout {
    
    enum Size {
        enum Event {
            static let width: CGFloat = 358
            static let height: CGFloat = 184
        }
        
        enum Item {
            static let width: CGFloat = 171
            static let height: CGFloat = 235
        }
        
        enum Header {
            static let height: CGFloat = 40
        }
        
        static let cellInterspacing: CGFloat = 16
    }
    
    
    func eventLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Event.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                          leading: 16,
                                                          bottom: 0,
                                                          trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.boundarySupplementaryItems = createSupplementaryView()
        return section
    }

    private func itemLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Size.Item.width), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Item.height))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(Size.cellInterspacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Size.cellInterspacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.boundarySupplementaryItems = createSupplementaryView()
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10)
        return section
    }
    
    
    private func createSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                           heightDimension: .absolute(Size.Header.height)),
                                                                        elementKind: "ItemHeaderTitleView", alignment: .top)
        sectionHeader.pinToVisibleBounds = true // 고정
        return [sectionHeader]
    }
}

extension EventHomeSectionLayout {
    func tabLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80),
                                               heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: .zero,
                                                        leading: 10,
                                                        bottom: .zero,
                                                        trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func itemContainerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}

extension EventHomeSectionLayout {
    
    func section(at type: PersonalViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .event:
            return eventLayout()
        case .item:
            return itemLayout()
        }
    }
    
    func section(at type: ContainerCell.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .event:
            return eventLayout()
        case .item:
            return itemLayout()
        }
    }
    
    func section(at type: CollectionViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .tab:
            return tabLayout()
        case .itemContainer:
            return itemContainerLayout()
        }
    }
}
