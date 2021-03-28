//
//  RecipeAnalysisResponse.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import Foundation

struct RecipeAnalysis : BaseModel {
    let calories : Int?
    let cautions : [String]?
    let dietLabels : [String]?
    let healthLabels : [String]?
    let totalNutrients : [String: Nutrient]?
    let uri : String?
    let yield : Int?
}

struct Nutrient: BaseModel {
    let label : String?
    let quantity : Float?
    let unit : String?
}
