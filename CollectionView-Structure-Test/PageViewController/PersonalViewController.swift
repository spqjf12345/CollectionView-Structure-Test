//
//  PersonalViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit
import SnapKit

protocol ScrollDelegate: AnyObject {
    func scrollUp(to height: CGFloat)
    func scrollDown(to height: CGFloat)
}

struct ItemCard: Hashable {
    var uuid = UUID()
    var imageUrl: UIImage
    var itemName: String
    var convinientStoreTagImage: UIImage
    var eventTagImage: UIImage
}

class PersonalViewController: UIViewController {

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
    
    private var refreshControl = UIRefreshControl()
    
    private var currentContentOffsetY: CGFloat = 0
    private var lastContentOffSetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDummyData()
        configureUI()
        configureDatasource()
        configureHeaderView()
        makeSnapshot()
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
        setNavigationView()
        setupCollectionView()
        setupViews()
    }
    
    private func setNavigationView() {
        title = "이벤트"
        tabBarItem = UITabBarItem(title: "이벤트",
                                  image: UIImage(systemName: "square.and.arrow.up"),
                                  selectedImage: UIImage(systemName: "square.and.arrow.up.fill"))
    }
    
    private func setupCollectionView() {
        registerCollectionViewCells()
        setRefreshControl()
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
    
    private func setRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(pullToRefresh),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func pullToRefresh() {
        collectionView.refreshControl?.beginRefreshing()
        
        //get data from api
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.makeSnapshot()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
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


extension PersonalViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffSetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentContentOffsetY = scrollView.contentOffset.y
        print("inset \(currentContentOffsetY)")
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
