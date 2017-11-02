//
//  Recipe.swift
//  RecipeCollection
//
//  Created by Damodar Shenoy on 10/1/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import Foundation

enum RecipeError: Error {
    case noTitle
}

enum RecipeType: String {
    case Breakfast = "Breakfast"
    case Dry = "Dry"
    case Gravy = "Gravy"
    case Snack = "Snack"
    case Meal = "Meal"
    case None = "None"
    
    static var numberOfTypes: Int {
        get {
            return 5
        }
    }
    subscript(index: Int) -> RecipeType {
        get {
            switch index {
            case 0:
                return .Breakfast
            case 1:
                return .Dry
            case 2:
                return .Gravy
            case 3:
                return .Snack
            case 4:
                return .Meal
            default:
                return .None
            }
        }
    }
    
    subscript(type: String) -> Int {
        get {
            switch type {
            case RecipeType.Breakfast.rawValue:
                return 0
            case RecipeType.Dry.rawValue:
                return 1
            case RecipeType.Gravy.rawValue:
                return 2
            case RecipeType.Snack.rawValue:
                return 3
            case RecipeType.Meal.rawValue:
                return 4
            default:
                return 5
            }
        }
    }
}

struct Recipe {
    let title: String
    var description: String?
    let type: RecipeType
    var imageURL: String?
    
    init(recipe: RecipeJSON) throws {
        guard let title = recipe["title"] else {
            throw RecipeError.noTitle
        }
        
        self.title = title
        self.description = recipe["description"] ?? ""
        self.imageURL = recipe["imageURL"] ?? ""
        
        if let type = RecipeType(rawValue: (recipe["type"] ?? "None")) {
            self.type = type
        } else {
            self.type = .None
        }
    }
    
    init(title: String, type: RecipeType) {
        self.title = title
        self.type = type
    }
}
