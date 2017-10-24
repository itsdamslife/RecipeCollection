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
        let cell: RecipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RecipeCell
        cell.recipe = dataSrc.recipe(at: indexPath.row)
        return cell
    }
// /* Alternative method to handle alternative selection */
//    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let rdvc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
//        rdvc.dataSource = dataSrc
//        rdvc.indexOfRecipe = indexPath.row
//        
//        self.navigationController?.pushViewController(rdvc, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "master2detail" {
            if let indexPath: IndexPath = self.collectionView?.indexPathsForSelectedItems?.first {
                if let recipe = dataSrc.recipe(at: indexPath.row) {
                    let rdvc: RecipeDetailViewController? = segue.destination as? RecipeDetailViewController
                    rdvc?.recipe = recipe
                }
            }
        }
    }
}
