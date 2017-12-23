//
//  RecipeCell.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 10/24/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import Foundation
import UIKit

class RecipeCell: UICollectionViewCell {
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var gradient: GradientView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    public var isEditing: Bool = false {
        didSet {
            checkImageView.isHidden = !isEditing
        }
    }
    
    var moving: Bool = false {
        didSet {
            let alpha: CGFloat = moving ? 0.0 : 1.0
            recipeTitleLabel.alpha = alpha
            gradient.alpha = alpha
        }
    }
    
    var snapshot: UIView? {
        get {
            let snapshot = snapshotView(afterScreenUpdates: true)
            let layer = snapshot?.layer
            layer?.masksToBounds = false
            layer?.shadowOffset = CGSize(width: -5.0, height: 0.0)
            layer?.shadowRadius = 5.0
            layer?.shadowOpacity = 0.4
            return snapshot
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                checkImageView.image = UIImage(named: (isSelected ? "Checked" : "Unchecked"))
            }
        }
    }
    
    var recipe: Recipe? {
        didSet {
            recipeTitleLabel.text = recipe?.title ?? "NOT FOUND"
        }
    }
}
