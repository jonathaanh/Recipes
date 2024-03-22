//
//  NetworkManager.swift
//  Recipes
//
//  Created by Jonathan Hsu on 3/15/24.
//

import Foundation

// NetworkManager is responsible for handling network requests to fetch meal data.
class NetworkManager {
    
    // Fetches a list of meals of a specific category (e.g., Dessert) from the API.
    func fetchMeals(completion: @escaping (MealList?) -> Void) {
        // URL string pointing to the meal database API for a specific category.
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        // Safely unwraps the URL string into a URL object.
        guard let url = URL(string: urlString) else { return }

        // Creates a data task to fetch data from the URL.
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handles any error that occurred during the network request.
            if let error = error {
                print("Error fetching meal details: \(error)")
                // Returns nil to the completion handler to indicate failure.
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Ensures that data received from the network request is not nil.
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            // Attempts to decode the received data into a MealList object.
            do {
                let mealList = try JSONDecoder().decode(MealList.self, from: data)
                // Passes the decoded meal list to the completion handler.
                DispatchQueue.main.async {
                    completion(mealList)
                }
            } catch {
                print("Error decoding meal list: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume() // Starts the network request.
    }

    // Fetches detailed information about a specific meal by its id.
    func fetchMealDetail(id: String, completion: @escaping (MealDetail?) -> Void) {
        // Constructs the URL string with the meal's id for the API request.
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        // Safely unwraps the URL string into a URL object.
        guard let url = URL(string: urlString) else { return }

        // Creates a data task to fetch data from the URL.
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handles any error that occurred during the network request.
            if let error = error {
                print("Error fetching meal details: \(error)")
                // Returns nil to the completion handler to indicate failure.
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Ensures that data received from the network request is not nil.
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Attempts to decode the received data into a MealResponse object.
            do {
                let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                // Assumes the first meal detail in the response is the one we're interested in.
                let mealDetail = mealResponse.meals.first
                // Passes the meal detail to the completion handler.
                DispatchQueue.main.async {
                    completion(mealDetail)
                }
            } catch {
                print("Error decoding meal detail: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume() // Starts the network request.
    }

}
