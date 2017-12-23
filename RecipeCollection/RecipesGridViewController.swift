//
//  RecipesGridViewController.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 10/1/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import Foundation
import UIKit

let ENABLE_CELL_MOVEMENT: Bool = false

class RecipesGridViewController: UICollectionViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let cellIdentifier = "RecipeCell"
    let secHdrIdentifier = "sectionheader"
    
    let dataSrc = RecipeDataSource()
    
    private var snapshot: UIView?
    private var sourceIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
        navigationItem.leftBarButtonItem = editButtonItem
        
        let width = collectionView!.frame.width / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)

        if ENABLE_CELL_MOVEMENT {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            collectionView?.addGestureRecognizer(longPress)
        }
    }
    
    // For moving cells
    func handleLongPress(_ recognizer: UILongPressGestureRecognizer) -> Void {
        print("Long press handled!!")
        
        guard !isEditing else { return }
        
        let location = recognizer.location(in: collectionView)
        let indexPath = collectionView!.indexPathForItem(at: location)
        
        switch recognizer.state {
        case .began:
            if let indexPath = indexPath {
                sourceIndexPath = indexPath
                let cell = collectionView!.cellForItem(at: indexPath) as! RecipeCell
                snapshot = cell.snapshot
                updateSnapshotView(center: cell.center, transform: CGAffineTransform.identity, alpha: 0.0)
                collectionView!.addSubview(snapshot!)
                UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                    self.updateSnapshotView(center: cell.center, transform: CGAffineTransform.init(scaleX: 1.05, y: 1.05), alpha: 0.95)
                    cell.moving = true
                })
            }
        case .changed:
            print("changed")
            self.snapshot!.center = location
            if let ip = indexPath {
                // Need to add data source modifications.
                collectionView!.moveItem(at: sourceIndexPath!, to: ip)
            }
        case .possible:
            print("Possible")
            fallthrough
        case .ended:
            print("ended")
            fallthrough
        case .cancelled:
            print("cancelled")
            fallthrough
        case .failed:
            print("failed")
            fallthrough
        default:
            let cell = collectionView!.cellForItem(at: sourceIndexPath!) as! RecipeCell
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                self.updateSnapshotView(center: cell.center, transform: CGAffineTransform.identity, alpha: 0.0)
                cell.moving = false
            }, completion: { [unowned self] finished in
                self.snapshot!.removeFromSuperview()
                self.snapshot = nil
            })
        }
    }
    
    
    func updateSnapshotView(center: CGPoint, transform: CGAffineTransform, alpha: CGFloat) {
        if let snapshot = snapshot {
            snapshot.center = center
            snapshot.transform = transform
            snapshot.alpha = alpha
        }
    }
    
    /// MARK: Add selectors "#selector(RecipesGridViewController.deleteRecipe(_:))"
    @IBAction func deleteRecipe(_ sender: Any?) {
        guard let indices2Del = collectionView?.indexPathsForSelectedItems else {
            return
        }
        
        let layout = collectionViewLayout as! RecipesFlowLayout
        layout.disappearingItemsIndexPaths = indices2Del
        
        for indexPath in indices2Del {
            // Remove from model
            dataSrc.deleteRecipe(at: indexPath)
        }
        
        
        // Update the view
        UIView.animate(withDuration: 0.65,
        delay: 0.0,
        options: .curveEaseIn,
        animations: { [unowned self] in
            self.collectionView?.deleteItems(at: indices2Del)
        }, completion: { _ in
            layout.disappearingItemsIndexPaths = nil
        })
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
        cell.isEditing = isEditing
        return cell
    }
 
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.isEditing {
            navigationController?.setToolbarHidden(false, animated: true)
        } else {
            performSegue(withIdentifier: "master2detail", sender: dataSrc.recipe(at: indexPath))
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if collectionView.indexPathsForSelectedItems?.count == 0 {
                navigationController?.setToolbarHidden(true, animated: true)
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addButton.isEnabled = !editing
        collectionView?.allowsMultipleSelection = editing
        let indpaths = collectionView?.indexPathsForVisibleItems
        for ip in indpaths! {
            collectionView!.deselectItem(at: ip, animated: false)
            let cell = collectionView!.cellForItem(at: ip) as? RecipeCell
            cell?.isEditing = editing
        }
        
        if !editing {
            navigationController?.setToolbarHidden(true, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "master2detail" {
            let rdvc: RecipeDetailViewController? = segue.destination as? RecipeDetailViewController
            rdvc?.recipe = sender as? Recipe
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
