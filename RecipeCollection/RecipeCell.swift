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
