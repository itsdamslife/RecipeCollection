//
//  SectionHeaderView.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 10/25/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}
