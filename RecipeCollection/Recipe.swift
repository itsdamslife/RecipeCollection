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
}

struct Recipe {
    let title: String
    let description: String?
    let type: RecipeType
    let imageURL: String?
    
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
}
