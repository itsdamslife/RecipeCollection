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
    var recipe: Recipe?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let r = recipe {
            titleLabel.text = r.title
        } else {
            titleLabel.text = "Not found"
        }
    }
}
