//
//  ContainerCell.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

class ContainerCell: UICollectionViewCell {
    enum SectionType: Hashable {
        case event
        case item
    }
    
    enum ItemType: Hashable {
        case event(data: String)
        case item(data: ItemCard)
    }

    private var dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>?
    private var itemCards: [ItemCard] = []
    private var eventUrls: [String] = []
    weak var delegate: ScrollDelegate?
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        return collectionView
    }()
    
    var currentContentOffsetY: CGFloat = 0
    var lastContentOffSetY: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupDummyData()
        setupViews()
        configureUI()
        configureDatasource()
        configureHeaderView()
        makeSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDummyData() {
        itemCards = DummyData.itemData
        eventUrls = ["test"]
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
    
    private func configureUI() {
        //TO DO : fix color
        collectionView.backgroundColor = .gray
        collectionView.delegate = self
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        registerCollectionViewCells()
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(ItemHeaderTitleView.self,
                                forSupplementaryViewOfKind: "ItemHeaderTitleView",
                                withReuseIdentifier: "ItemHeaderTitleView")
        collectionView.register(EventBannerCell.self,
                                forCellWithReuseIdentifier: "EventBannerCell")
        collectionView.register(ProductCell.self,
                                forCellWithReuseIdentifier: "ProductCell")
    }
    
    private func setupViews() {
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureDatasource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .item(let item):
                let cell: ProductCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell",
                                                                            for: indexPath) as? ProductCell
                return cell ?? UICollectionViewCell()
            case .event(let item):
                let cell: EventBannerCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "EventBannerCell", for: indexPath) as? EventBannerCell
                cell?.update(self.eventUrls)
                return cell ?? UICollectionViewCell()
            }
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = makeSupplementaryView
    }
    
    private func makeSupplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        switch kind {
            case "ItemHeaderTitleView":
            let itemHeaderTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: kind,
                                                                                      for: indexPath) as? ItemHeaderTitleView
            itemHeaderTitleView?.update()
            return itemHeaderTitleView
        default:
            return nil
        }
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        //append event section
        if !eventUrls.isEmpty {
            snapshot.appendSections([.event])
            let eventUrls = eventUrls.map { eventUrl in
                return ItemType.event(data: eventUrl)
            }
            snapshot.appendItems(eventUrls, toSection: .event)
        }
        
        //append item section
        if !itemCards.isEmpty {
            snapshot.appendSections([.item])
            let itemCards = itemCards.map { itemCard in
                return ItemType.item(data: itemCard)
            }
            snapshot.appendItems(itemCards, toSection: .item)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


extension ContainerCell: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffSetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentContentOffsetY = scrollView.contentOffset.y
        if self.lastContentOffSetY < self.currentContentOffsetY {
            //header height를 0
            print("header height를 0")
            delegate?.scrollUp(to: currentContentOffsetY)
        } else {
            //header height를 늘림
            print("header height를 늘림")
            delegate?.scrollDown(to: currentContentOffsetY)
        }
    }
}
