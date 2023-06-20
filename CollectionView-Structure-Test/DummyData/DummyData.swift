//
//  DummyData.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/18.
//

import UIKit

class DummyData {
    static let dummyImage = UIImage(systemName: "note")!

    static let itemData: [ItemCard] = [
        ItemCard(imageUrl: dummyImage,
                 itemName: "산리오)햄치즈에그모닝머핀ddd",
                 convinientStoreTagImage: dummyImage,
                 eventTagImage: dummyImage),
        ItemCard(imageUrl: dummyImage,
                 itemName: "나가사끼 짬뽕",
                 convinientStoreTagImage: dummyImage,
                 eventTagImage: dummyImage),
        ItemCard(imageUrl: dummyImage,
                 itemName: "나가사끼 짬뽕",
                 convinientStoreTagImage: dummyImage,
                 eventTagImage: dummyImage),
        ItemCard(imageUrl: dummyImage,
                 itemName: "나가사끼 짬뽕",
                 convinientStoreTagImage: dummyImage,
                 eventTagImage: dummyImage),
        ItemCard(imageUrl: dummyImage,
                 itemName: "나가사끼 짬뽕",
                 convinientStoreTagImage: dummyImage,
                 eventTagImage: dummyImage),
        ItemCard(imageUrl: dummyImage,
                 itemName: "나가사끼 짬뽕",
                 convinientStoreTagImage: dummyImage,
                 eventTagImage: dummyImage)
    ]
    
    static let tabData: [Tab] = [Tab(name: "전체", isSelected: true),
                                  Tab(name: "GS25"),
                                  Tab(name: "이마트24"),
                                  Tab(name: "세븐일레븐"),
                                  Tab(name: "CU")]
}
