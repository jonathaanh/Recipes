//
//  MealListView.swift
//  Recipes
//
//  Created by Jonathan Hsu on 3/15/24.
//

import Foundation
import SwiftUI

struct MealListView: View {
    @ObservedObject var viewModel = MealListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(mealId: meal.id)) {
                    HStack {
                        if let imageUrl = URL(string: meal.strMealThumb) {
                            AsyncImage(url: imageUrl) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                        }
                        Text(meal.strMeal)
                    }
                }
            }
            .navigationBarTitle("Desserts")
            .onAppear {
                viewModel.fetchMeals()
            }
        }
    }
}
