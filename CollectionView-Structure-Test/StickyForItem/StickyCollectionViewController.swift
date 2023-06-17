//
//  StickyCollectionViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

class StickyCollectionviewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        //stick 될 cells
//        let indexPaths = [IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1), IndexPath(row: 2, section: 1), IndexPath(row: 3, section: 1), IndexPath(row: 4, section: 1)]
        collectionView.collectionViewLayout = StickyFlowLayout(stickyIndexPaths: [IndexPath(row: 1, section: 0)])
        registerCollectionviewCell()
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.backgroundColor = .brown
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func registerCollectionviewCell() {
        collectionView.register(HeaderContainerCell.self, forCellWithReuseIdentifier: "HeaderContainerCell")
        collectionView.register(TabContainerCell.self, forCellWithReuseIdentifier: "TabContainerCell")
        collectionView.register(ContainerCell.self, forCellWithReuseIdentifier: "ContainerCell")
        
    }
}

extension StickyCollectionviewController: UICollectionViewDelegate {
    
}

extension StickyCollectionviewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderContainerCell", for: indexPath) as? HeaderContainerCell
            return cell ?? UICollectionViewCell()
        }else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabContainerCell", for: indexPath) as? TabContainerCell
            return cell ?? UICollectionViewCell()
        }else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContainerCell", for: indexPath) as? ContainerCell
            return cell ?? UICollectionViewCell()
        }
        return UICollectionViewCell()
        
        
    }
    
    
}

extension StickyCollectionviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        print(indexPath)
        if indexPath.row == 0 || indexPath.row == 1 {
            return CGSize(width: width, height: 60)
        }
        return CGSize(width: width, height: 1200)
    }
}
