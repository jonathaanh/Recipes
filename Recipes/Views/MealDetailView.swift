//
//  MealDetailView.swift
//  Recipes
//
//  Created by Jonathan Hsu on 3/15/24.
//

import Foundation
import SwiftUI

struct MealDetailView: View {
    let mealId: String
    @ObservedObject var viewModel = MealDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack{
                    Spacer()
                    if let imageUrl = URL(string: viewModel.mealDetail?.strMealThumb ?? "") {
                        AsyncImage(url: imageUrl) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200, height:200)
                        .cornerRadius(8)
                    }
                    Spacer()
                }
                
                Text("Instructions")
                    .font(.headline)

                Text(viewModel.mealDetail?.strInstructions ?? "")
                    .padding(.bottom, 10)

                Text("Ingredients & Measurements:")
                    .font(.headline)
           
                ForEach(viewModel.mealDetail?.ingredients ?? []) { ingredient in
                    Text("\(ingredient.name): \(ingredient.measurement)")
                }
            }
            .padding()
        }
        .navigationBarTitle(Text(viewModel.mealDetail?.strMeal ?? ""), displayMode: .inline)
        .onAppear {
            self.viewModel.fetchMealDetail(mealId: self.mealId)
        }
    }
}
