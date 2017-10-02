//
//  RecipesGridViewController.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 10/1/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import Foundation
import UIKit

class RecipesGridViewController: UICollectionViewController {
    
    let cellIdentifier = "RecipeCell"
    let dataSrc = RecipeDataSource()
    
    override func viewDidLoad() {
        let width = collectionView!.frame.width / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSrc.recipeCount()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let rdvc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        rdvc.dataSource = dataSrc
        rdvc.indexOfRecipe = indexPath.row
        
        self.navigationController?.pushViewController(rdvc, animated: true)
    }
}
