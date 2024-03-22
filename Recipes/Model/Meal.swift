//
//  Meal.swift
//  Recipes
//
//  Created by Jonathan Hsu on 3/15/24.
//

import Foundation

// Defines a basic structure for a meal that includes essential properties such as the meal's ID, name, and thumbnail URL. Conforms to Codable for JSON decoding and Identifiable for use in SwiftUI lists.
struct Meal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    var id: String { idMeal } // Computed property to satisfy the Identifiable protocol.
}

// A structure to encapsulate a list of meals, making it easier to decode JSON structures that represent an array of meals.
struct MealList: Codable {
    let meals: [Meal]
}

// Represents the response structure for a detailed meal request, containing an array of MealDetail instances.
struct MealResponse: Codable {
    let meals: [MealDetail]
}

// Detailed information about a meal, including instructions and a list of ingredients with measurements.
// Custom decoding is implemented to handle dynamic keys for ingredients and measurements.
struct MealDetail: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String
    var id: String { idMeal }
    var ingredients: [Ingredient]

    // Nested structure for an ingredient, which includes a name and measurement.
    // Each Ingredient is identifiable by a unique ID.
    struct Ingredient : Identifiable {
        let id = UUID()
        let name: String
        let measurement: String
    }

    // Coding keys for decoding static properties.
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions
    }
    
    // DynamicCodingKeys to handle the dynamic nature of ingredient and measurement keys.
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }
}

extension MealDetail {
    // Custom initializer to decode a MealDetail instance.
    // This initializer specifically handles the dynamic decoding of ingredients and their measurements.
    init(from decoder: Decoder) throws {
        // Decoding static properties using predefined coding keys.
        let staticContainer = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try staticContainer.decode(String.self, forKey: .idMeal)
        strMeal = try staticContainer.decode(String.self, forKey: .strMeal)
        strMealThumb = try staticContainer.decode(String.self, forKey: .strMealThumb)
        strInstructions = try staticContainer.decode(String.self, forKey: .strInstructions)

        // Decoding dynamic properties for ingredients and measurements.
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var ingredientsTemp: [Ingredient] = []
        
        // Iterates over all keys to find and decode ingredients and their corresponding measurements.
        for key in dynamicContainer.allKeys {
            if key.stringValue.starts(with: "strIngredient") {
                let measureKeyStr = key.stringValue.replacingOccurrences(of: "strIngredient", with: "strMeasure")
                if let ingredientName = try dynamicContainer.decodeIfPresent(String.self, forKey: key),
                   !ingredientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                   let measureKey = DynamicCodingKeys(stringValue: measureKeyStr) {
                    let measurement = (try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey)) ?? ""
                    ingredientsTemp.append(Ingredient(name: ingredientName, measurement: measurement))
                }
            }
        }

        ingredients = ingredientsTemp
    }
}


