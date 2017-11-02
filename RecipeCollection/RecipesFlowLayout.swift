//
//  RecipesFlowLayout.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 11/2/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import UIKit

class RecipesFlowLayout: UICollectionViewFlowLayout {
    var appearingIndexPath: IndexPath?
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)

        if let indexPath = appearingIndexPath,
            let attributes = attributes,
            indexPath == itemIndexPath {
            attributes.alpha = 1.0
            attributes.center = CGPoint(x: collectionView!.frame.width - 23.5, y: -24.5)
            attributes.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
            attributes.zIndex = 99
        }
        return attributes
    }
}
