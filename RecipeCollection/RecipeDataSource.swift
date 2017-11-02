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
    
    func indexPath(of recipe: Recipe) -> IndexPath {
        var idp = IndexPath(row: 0, section: 0)
        for value in recipes {
            if value.title == recipe.title {
                idp.section = value.type[value.type.rawValue]
                idp.row = recipeCount(at: idp.section) - 1
                break
            }
        }
        return idp
    }
    
    public func recipeCount() -> Int {
        return recipes.count
    }
    
    func recipe(at index: Int) -> Recipe? {
        return (recipes.count > index) ? recipes[index] : nil
    }
    
    public func addRecipe(recipe: Recipe) -> Bool {
        recipes.append(recipe)
        return true
    }
    
    public func deleteRecipe(recipe: Recipe) {
        
        var i = 0
        for (index, value) in recipes.enumerated() {
            if value.title == recipe.title {
                i = index
                break
            }
        }
        recipes.remove(at: i)
    }
    
    fileprivate class func parseRecipes(recipesJSON: [RecipeJSON]) -> [Recipe] {
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

extension RecipeDataSource {
    fileprivate class func loadRecipesFromDisk() -> [Recipe] {
        
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
    
    func addNewRecipe() -> IndexPath? {
        var newtitle = ""
        // Copied and added this file(2.5MB) --> `/usr/share/dict/web2` to the project
        if let wordsFilePath = Bundle.main.path(forResource: "web2", ofType: nil) {
            do {
                let wordsString = try String(contentsOfFile: wordsFilePath)
                let wordLines = wordsString.components(separatedBy: .newlines)
                let randomLine = wordLines[numericCast(arc4random_uniform(numericCast(wordLines.count)))]
                newtitle = randomLine
            } catch { // contentsOfFile throws an error
                print("Error: \(error)")
            }
        }
        
        let typ = RecipeType.None
        let type: RecipeType = typ[Int(arc4random_uniform(UInt32(RecipeType.numberOfTypes)))]
        
        var r = Recipe(title: newtitle, type: type)
        r.description = "Added \(newtitle) recipe now to \(type.rawValue)"
        
        print("NEW RECIPE: \(r.description ?? "")")
        
        if self.addRecipe(recipe: r) {
            return self.indexPath(of: r)
        }
        
        return nil
    }
}


