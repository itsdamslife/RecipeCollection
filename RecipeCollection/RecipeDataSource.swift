//
//  RecipeDataSource.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 10/1/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import Foundation

typealias RecipeJSON = Dictionary<String, String>


class RecipeDataSource {
    
    var recipes: [Recipe]
    
    init() {
        recipes = RecipeDataSource.loadRecipesFromDisk()
    }
    
    // MARK: New methods
    public func numberOfSections() -> Int {
// use filter to check if category has items
        return RecipeType.numberOfTypes
    }
    
    public func title(at section: Int) -> String? {
        var title: String? = nil
        if let typ = RecipeType(rawValue: "None") {
            title = "\(typ[section].rawValue) (\(recipeCount(at: section)))"
        }
        return title
    }
    
    public func recipeCount(at section: Int) -> Int {
        let count = recipes.reduce(0) { result, recipe in
            var res = result
            guard let typ = RecipeType(rawValue: "None") else { return 0 }
            if typ[section] == recipe.type { res += 1 }
            return res
        }
        return count
    }
    
    func recipe(at indexPath: IndexPath) -> Recipe? {
        guard let typ = RecipeType(rawValue: "None") else { return nil }
        return recipes.filter {
            if $0.type == typ[indexPath.section] {
                return true
            }
            return false
        }[indexPath.row]
    }
    
    // MARK: Old methods
    public func recipeCount() -> Int {
        return recipes.count
    }
    
    func recipe(at index: Int) -> Recipe? {
        return (recipes.count > index) ? recipes[index] : nil
    }
    
    public func addRecipe(recipe: Recipe) {
        
    }
    
    public func deleteRecipe(recipe: Recipe) {
        
    }
    
    private class func loadRecipesFromDisk() -> [Recipe] {
        
        var recipes = [Recipe]()
        guard let recipesFilePath = Bundle.main.path(forResource: "Recipes", ofType: "plist") else {
            return recipes
        }
        
        guard let data = FileManager.default.contents(atPath: recipesFilePath) else {
            return recipes
        }
        
        do {
            let recipeList = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainers, format: nil) as! [RecipeJSON]
            recipes = RecipeDataSource.parseRecipes(recipesJSON: recipeList)
        } catch {
            print("File read ERROR")
        }
        return recipes
    }
    
    private class func parseRecipes(recipesJSON: [RecipeJSON]) -> [Recipe] {
        var recipes: [Recipe] = [Recipe]()
        for recipeJSON in recipesJSON {
            do {
                let recipe = try Recipe(recipe: recipeJSON)
                recipes.append(recipe)
            } catch {
                print("FATAL ERROR : \(recipeJSON)")
            }
        }
        return recipes
    }
    
}
