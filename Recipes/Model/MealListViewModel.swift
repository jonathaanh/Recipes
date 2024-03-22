//
//  MealListViewModel.swift
//  Recipes
//
//  Created by Jonathan Hsu on 3/15/24.
//

import Foundation

// Responsible for managing and providing a list of meals to the UI.
class MealListViewModel: ObservableObject {
    // A published property that holds an array of Meal objects
    @Published var meals = [Meal]()

    // Fetches a list of meals via the NetworkManager.
    func fetchMeals() {
        NetworkManager().fetchMeals { mealList in
            // This triggers an update in the UI observing the meals property.
            if let mealList = mealList {
                self.meals = mealList.meals
            }
        }
    }
}
