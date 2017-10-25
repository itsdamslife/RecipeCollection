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
//        recipes.reduce(0) { result, recipe in
//
//        }
        return 5
    }
    
    public func title(at section: Int) -> String? {
        var title: String? = nil
        if section == 0 { title = RecipeType.Breakfast.rawValue }
        else if section == 1 { title = RecipeType.Dry.rawValue }
        else if section == 2 { title = RecipeType.Gravy.rawValue }
        else if section == 3 { title = RecipeType.Snack.rawValue }
        else if section == 4 { title = RecipeType.Meal.rawValue }
        return title
    }
    
    public func recipeCount(at section: Int) -> Int {
        let count = recipes.reduce(0) { result, recipe in
            var res = result
            if section == 0, recipe.type == .Breakfast { res += 1 }
            else if section == 1, recipe.type == .Dry { res += 1 }
            else if section == 2, recipe.type == .Gravy { res += 1 }
            else if section == 3, recipe.type == .Snack { res += 1 }
            else if section == 4, recipe.type == .Meal { res += 1 }
            return res
        }
        return count
    }
    
    func recipe(at indexPath: IndexPath) -> Recipe? {
        return (recipes.count > indexPath.row) ? recipes[indexPath.row] : nil
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
