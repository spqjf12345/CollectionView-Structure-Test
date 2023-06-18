//
//  CollectionViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit
import SnapKit

class CollectionViewController: UIViewController {
    
    enum SectionType: Hashable {
        case tab
        case itemContainer
    }
    
    enum ItemType: Hashable {
        case tab(data: Tab)
        case itemContainer(data: String)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>?
    let tabData: [Tab] = [Tab(name: "전체"),
                          Tab(name: "GS25"),
                          Tab(name: "이마트24"),
                          Tab(name: "세븐일레븐"),
                          Tab(name: "CU")]
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        registerCollectionviewCell()
        configureDatasource()
        makeSnapshot()
    }
    
    private func registerCollectionviewCell() {
        collectionView.register(UINib(nibName: "TabCell", bundle: nil), forCellWithReuseIdentifier: "TabCell")
        collectionView.register(ContainerCell.self, forCellWithReuseIdentifier: "ContainerCell")
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(collectionView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = EventHomeSectionLayout()
            return layout.section(at: sectionIdentifier)
        }
    }
    

    
    private func configureDatasource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .tab(let tab):
                let cell: TabCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell",
                                                                            for: indexPath) as? TabCell
                cell?.update(with: tab)
                print(tab)
                return cell ?? UICollectionViewCell()
            case .itemContainer(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContainerCell",
                                                              for: indexPath) as? ContainerCell
                let colors: [UIColor] = [.black, .blue, .brown, .cyan, .purple]
                cell?.backgroundColor = colors[indexPath.row]
                cell?.delegate = self
                return cell ?? UICollectionViewCell()
            }
        }
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        //append tab section

        if !tabData.isEmpty {
            let tabs = tabData.map { tab in
                return ItemType.tab(data: tab)
            }
            let itemContainer = tabData.map { item in
                return ItemType.itemContainer(data: item.name)
            }
            snapshot.appendSections([.tab])
            snapshot.appendItems(tabs, toSection: .tab)
            snapshot.appendSections([.itemContainer])
            snapshot.appendItems(itemContainer, toSection: .itemContainer)
        }
    
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension CollectionViewController: ScrollDelegate {
    
    func scrollUp(to height: CGFloat) {
        let inset = 100 - height
        if abs(height) < 100 {
            self.headerView.snp.updateConstraints {
                $0.top.equalTo(inset)
            }
        }
        else {
            self.headerView.snp.updateConstraints {
                $0.top.equalTo(0)
            }
        }
    }
    
    func scrollDown(to height: CGFloat) {
        let inset = 100 - height
        if height < 0 {
            UIView.animate(withDuration: 0.2) {
                self.headerView.snp.updateConstraints {
                    $0.top.equalTo(inset)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
