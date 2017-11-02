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
    let secHdrIdentifier = "sectionheader"
    let dataSrc = RecipeDataSource()
    
    override func viewDidLoad() {
        let width = collectionView!.frame.width / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSrc.numberOfSections()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSrc.recipeCount(at: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let secHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: secHdrIdentifier, for: indexPath) as! SectionHeaderView
        if let title: String = dataSrc.title(at: indexPath.section) {
            secHeaderView.title = title
        }
        return secHeaderView
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RecipeCell
        cell.recipe = dataSrc.recipe(at: indexPath)
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
    
    @IBAction func addNewRecipe(_ sender: Any) {
        if let indexPath = dataSrc.addNewRecipe() {
            self.updateCollectionView(indexPath)
        }
    }
    
    func updateCollectionView(_ indexPath: IndexPath) {
        
        let layout = collectionViewLayout as! RecipesFlowLayout
        layout.appearingIndexPath = indexPath

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.65,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseInOut,
                       animations: { [unowned self] in
                            self.collectionView?.insertItems(at: [indexPath])
                       },
                       completion: { finished in
                            layout.appearingIndexPath = nil
                       })
    }
    
}
