//
//  RecipeDetailViewController.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 10/2/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var dataSource: RecipeDataSource!
    var indexOfRecipe: Int!
    
    override func viewDidLoad() {
        titleLabel.text = dataSource.recipe(at: indexOfRecipe)?.title ?? "Not found"
    }
}
