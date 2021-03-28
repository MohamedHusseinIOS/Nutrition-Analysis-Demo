//
//  IngredientAnalysis.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 27/03/2021.
//

import Foundation

struct IngredientAnalysis: BaseModel {
    let calories : Int?
    let cautions : [String]?
    let dietLabels : [String]?
    let healthLabels : [String]?
    let ingredients : [Ingredient]?
    let totalDaily : [String: Nutrient]?
    let totalNutrients : [String: Nutrient]?
    let totalNutrientsKCal: [String: Nutrient]?
    let totalWeight : Int?
    let uri : String?
}

struct Ingredient : Codable {
    let parsed : [Parsed]?
    let text : String?
}

struct Parsed : Codable {
    let food : String?
    let foodId : String?
    let foodMatch : String?
    let measure : String?
    let nutrients : [String: Nutrient]?
    let quantity : Int?
    let retainedWeight : Int?
    let weight : Int?
}
