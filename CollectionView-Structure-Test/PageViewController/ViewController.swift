//
//  ViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit
import SnapKit

protocol ViewControllerDelegate: AnyObject {
    func didTapCell()
}

/* ViewController -> headerView (네비게이션바)
    -> 편의점 리스트 collectionview
    -> PersonalPageViewController
        -> PersonalViewController
           -> collectionView (상품리스트) */

struct Tab: Hashable {
    var id = UUID()
    var name: String
    var isSelected: Bool = false
    
    mutating func updateSelectedState() {
        isSelected = false
    }
}

final class ViewController: UIViewController {
        
    enum Size {
        static let headerViewHeight: CGFloat = 50
    }
    
    let pageViewController = PersonalPageViewController(transitionStyle: .scroll,
                                                        navigationOrientation: .horizontal)
    let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let tabCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: width / 5, height: 40)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var isStickyed: Bool = false
    private var tabData: [Tab] = DummyData.tabData
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        view.backgroundColor = .white
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        pageViewController.pageDelegate = self
        pageViewController.scrollDelegate = self
        tabCollectionView.register(UINib(nibName: "TabCell", bundle: nil), forCellWithReuseIdentifier: "TabCell")
    }
    
    private func setLayout() {
        view.addSubview(headerView)
        view.addSubview(tabCollectionView)
        view.addSubview(contentView)
        headerView.backgroundColor = .red
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        tabCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.addSubview(pageViewController.view)
        addChild(pageViewController)
        
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
        
    }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as? TabCell else { return UICollectionViewCell() }
        cell.update(with: tabData[indexPath.row])
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
    private func updateSelectedTabCell(with index: Int) {
        for index in 0..<tabData.count {
            tabData[index].updateSelectedState()
        }
        tabData[index].isSelected = true
        tabCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            updateSelectedTabCell(with: indexPath.row)
            self.pageViewController.updatePage(indexPath.row)
        }
    }
}

extension ViewController: PersonalPageViewControllerDelegate {
    func updateTabCell(index: Int) {
        updateSelectedTabCell(with: index)
    }
}

extension ViewController: ScrollDelegate {
    func scrollUp(to height: CGFloat) {
        guard isStickyed == false else { return }
        let inset = Size.headerViewHeight - height
        if abs(height) < Size.headerViewHeight {
            self.tabCollectionView.snp.updateConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(inset)
            }
        } else {
            self.tabCollectionView.snp.updateConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(0)
            }
            self.isStickyed = true
        }

    }
    
    func scrollDown(to height: CGFloat) {
        let inset = Size.headerViewHeight
        if height < 0 {
            UIView.animate(withDuration: 0.2) {
                self.tabCollectionView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(inset)
                }
                self.isStickyed = false
                self.view.layoutIfNeeded()
            }
        }
    }

}
