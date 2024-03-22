//
//  MealDetailViewModel.swift
//  Recipes
//
//  Created by Jonathan Hsu on 3/15/24.
//

import Foundation

// Defines a ViewModel class responsible for fetching and holding the details of a specific meal.
class MealDetailViewModel: ObservableObject {
    // A published property that stores the details of a meal
    @Published var mealDetail: MealDetail?

    // Fetches the details of a meal by its ID.
    func fetchMealDetail(mealId: String) {
        NetworkManager().fetchMealDetail(id: mealId) { mealDetail in
            // Checks if the fetched mealDetail is not nil
            if let mealDetail = mealDetail {
                self.mealDetail = mealDetail
            }
        }
    }
}
