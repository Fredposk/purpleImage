//
//  UIHelpers.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 06.12.21.
//

import UIKit


enum UIHelper {

    static func configureSearchResultsLayout() -> UICollectionViewCompositionalLayout {
//        items
        let topRowItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))

        let largerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1)))

        let trailingLargerItemPair = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))

        let items: [NSCollectionLayoutItem] = [topRowItem, largerItem, trailingLargerItemPair]
        for item in items {
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        }
//        groups
        let topRowTripletGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), subitem: topRowItem, count: 3)

        let trailingLargerItemPairGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: trailingLargerItemPair, count: 2)

        let largerWithPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), subitems: [largerItem, trailingLargerItemPairGroup])

        let reversedPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), subitems: [trailingLargerItemPairGroup, largerItem])

        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)), subitems: [topRowTripletGroup, largerWithPairGroup, reversedPairGroup])
//        section
        let section = NSCollectionLayoutSection(group: nestedGroup)
        return UICollectionViewCompositionalLayout(section: section)

    }
}
