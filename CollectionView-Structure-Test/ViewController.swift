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

class ViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerHeightConstraints: NSLayoutConstraint!
    
    let pageViewController = PersonalPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let tabCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: width / 5, height: 40)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let tabData: [String] = ["전체", "GS25", "이마트24", "세븐일레븐", "CU"]
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(pageViewController.view)
        addChild(pageViewController)
        
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
        
        tabView.addSubview(tabCollectionView)
        tabCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        pageViewController.pageDelegate = self
        pageViewController.scrollDelegate = self
        tabCollectionView.register(UINib(nibName: "TabCell", bundle: nil), forCellWithReuseIdentifier: "TabCell")
        
    }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as? TabCell else { return UICollectionViewCell() }
        cell.update(with: tabData[indexPath.row])
        if indexPath.row == 0 {
            updateTabCell(index: 0)
        }
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            self.pageViewController.updatePage(indexPath.row)
        }
    }
}

extension ViewController: PersonalPageViewControllerDelegate {
    func updateTabCell(index: Int) {
        let moveIndexPath = IndexPath(item: index, section: 0)
        for item in 0..<tabData.count {
            let makedIndexPath = IndexPath(item: item, section: 0)
            if makedIndexPath == moveIndexPath {
                if let cell = tabCollectionView.cellForItem(at: makedIndexPath) as? TabCell {
                    cell.isSelected = true
                }
            }else {
                if let cell = tabCollectionView.cellForItem(at: makedIndexPath) as? TabCell {
                    cell.isSelected = false
                }
            }
            
        }
    }
}

extension ViewController: ScrollDelegate {
    func setHeaderHeight(to height: CGFloat) {
        if height == 0 {
            //hide
            UIView.animate(withDuration: 0.1) {
                self.headerHeightConstraints.constant = 0
                self.view.layoutIfNeeded()
            }
        }else {
            UIView.animate(withDuration: 0.1) {
                self.headerHeightConstraints.constant = height
                self.view.layoutIfNeeded()
            }
        }
        
//        let currentHeight = headerHeightConstraints.constant
//        if currentHeight == height { return }
        
    }
}
